extends Control

const CARD_SCENE = preload("res://Scenes/Card.tscn")

@onready var card_container: GridContainer = $ShopVBC/CenterContainer/CardGridContainer
@onready var relic_container: HBoxContainer = $ShopVBC/RelicHBoxContainer

func _ready() -> void:
	if not RunState.shop_generated:
		_generate_shop()
		RunState.shop_generated = true
	else:
		_rebuild_display()

# ─── Generation ───────────────────────────────────────────────────────────────

func _generate_shop() -> void:
	var weights := _card_weights_for_floor()
	for i in 10:
		var card = _pick_weighted(weights)
		if card:
			card = card.duplicate(true)
			card.uid = CardLibrary.get_next_uid()
			RunState.shop_cards.append(card)

	var relic_weights := {
		GlobalEnums.CardRarity.COMMON: 55,
		GlobalEnums.CardRarity.RARE: 35,
		GlobalEnums.CardRarity.LEGENDARY: 10,
	}
	for i in 3:
		var relic = _pick_weighted_relic(relic_weights)
		if relic:
			RunState.shop_relics.append(relic)

	_rebuild_display()

func _card_weights_for_floor() -> Dictionary:
	var weights := {
		GlobalEnums.CardRarity.COMMON: 50,
		GlobalEnums.CardRarity.RARE: 35,
		GlobalEnums.CardRarity.LEGENDARY: 15,
	}
	if RunState.current_floor > 5:
		weights[GlobalEnums.CardRarity.COMMON] -= 20
		weights[GlobalEnums.CardRarity.RARE]   += 15
		weights[GlobalEnums.CardRarity.LEGENDARY] += 5
	return weights

func _pick_weighted(weights: Dictionary) -> CardData:
	var total := 0
	for w in weights.values():
		total += w
	var roll := RunState.rng.randi_range(0, total - 1)
	var cumulative := 0
	for rarity in weights:
		cumulative += weights[rarity]
		if roll < cumulative:
			var pool = CardLibrary.get_cards_by_rarity(rarity)
			if pool.is_empty():
				return null
			return pool[RunState.rng.randi_range(0, pool.size() - 1)]
	return null

func _pick_weighted_relic(weights: Dictionary) -> RelicData:
	var total := 0
	for w in weights.values():
		total += w
	var roll := RunState.rng.randi_range(0, total - 1)
	var cumulative := 0
	for rarity in weights:
		cumulative += weights[rarity]
		if roll < cumulative:
			var pool = RelicLibrary.get_relics_by_rarity(rarity)
			if pool.is_empty():
				return null
			return pool[RunState.rng.randi_range(0, pool.size() - 1)]
	return null

# ─── Display ──────────────────────────────────────────────────────────────────
func _rebuild_display() -> void:
	# First run: create the fixed slot VBoxes
	if card_container.get_child_count() == 0:
		for i in RunState.shop_cards.size():
			var slot := VBoxContainer.new()
			slot.custom_minimum_size = Vector2(120, 0)
			card_container.add_child(slot)

	# Rebuild each slot's contents in place
	for i in RunState.shop_cards.size():
		var slot: VBoxContainer = card_container.get_child(i)
		for child in slot.get_children():
			child.queue_free()

		var card_data: CardData = RunState.shop_cards[i]
		if card_data == null:
			var sold_label := Label.new()
			sold_label.text = "Sold"
			sold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			sold_label.modulate.a = 0.4
			slot.add_child(sold_label)
			continue

		var card_node = CARD_SCENE.instantiate()
		card_node.setup(card_data)
		card_node.clicked.connect(_on_shop_card_clicked)
		slot.add_child(card_node)

		var price_label := Label.new()
		price_label.text = "%dg" % _card_price(card_data)
		price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.add_child(price_label)

	# Relics unchanged
	for child in relic_container.get_children():
		child.queue_free()
	for relic in RunState.shop_relics:
		if relic == null:
			relic_container.add_child(_make_sold_out_button(""))
			continue
		var btn := Button.new()
		btn.text = "%s\n%dg" % [relic.relic_name, _relic_price(relic)]
		btn.custom_minimum_size = Vector2(120, 80)
		btn.pressed.connect(_on_relic_purchased.bind(relic))
		relic_container.add_child(btn)

func _make_sold_out_button(label: String) -> Button:
	var btn := Button.new()
	btn.text = "Sold Out" if label.is_empty() else label + "\n(Sold)"
	btn.custom_minimum_size = Vector2(120, 80)
	btn.disabled = true
	return btn

# ─── Pricing ──────────────────────────────────────────────────────────────────

func _card_price(card: CardData) -> int:
	match card.rarity:
		GlobalEnums.CardRarity.COMMON:    return 50
		GlobalEnums.CardRarity.RARE:      return 100
		GlobalEnums.CardRarity.LEGENDARY: return 200
	return 50

func _relic_price(relic: RelicData) -> int:
	match relic.rarity:
		GlobalEnums.CardRarity.COMMON:    return 75
		GlobalEnums.CardRarity.RARE:      return 150
		GlobalEnums.CardRarity.LEGENDARY: return 300
	return 75

# ─── Purchases ────────────────────────────────────────────────────────────────
func _on_shop_card_clicked(card: Card) -> void:
	if not card:
		return
	var card_data: CardData = card.card_data
	var price := _card_price(card_data)
	if RunState.gold < price:
		# TODO: shake/flash "not enough gold"
		return
	RunState.gold -= price
	var copy := card_data.duplicate(true)
	copy.uid = CardLibrary.get_next_uid()
	RunState.deck.append(copy)
	RunState.shop_cards[RunState.shop_cards.find(card_data)] = null
	_rebuild_display()

func _on_relic_purchased(relic: RelicData) -> void:
	var price := _relic_price(relic)
	if RunState.gold < price:
		return
	RunState.gold -= price
	RunState.relics.append(relic)
	relic.on_collected.call()
	RunState.shop_relics[RunState.shop_relics.find(relic)] = null
	_rebuild_display()

# ─── Navigation ───────────────────────────────────────────────────────────────

func _on_continue_pressed() -> void:
	RunState.shop_generated = false
	RunState.shop_cards.clear()
	RunState.shop_relics.clear()
	RunState.map_data.get_current_node().cleared = true
	RunState.scene_history.clear()
	RunState.push_scene("res://Scenes/MapManager.tscn")
