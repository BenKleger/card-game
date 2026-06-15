class_name RewardManager
extends Node

const CARD_SCENE = preload("res://scenes/Card.tscn")

func _ready() -> void:
	offer_rewards()
var cards_offered : Array[CardData]

func offer_rewards():
	#enum MapNodeType { SHOP, COMBAT, ELITE, BOSS, LORE }
	
	cards_offered = []
	
	
	offer_cards()
	
	#Gold formula
	offer_gold()
	
	offer_relics()

var gold: int
@onready var card_container: HBoxContainer = $Rewards/slot4/CardContainer
@onready var relic_button: Button = $Rewards/slot2/RelicButton
func offer_relics() -> void:
	if RunState.relic_accepted == true:
		relic_button.queue_free()
		return
	var node = RunState.map_data.get_current_node()
	var rarity_weights = {
		GlobalEnums.CardRarity.COMMON: 50,
		GlobalEnums.CardRarity.RARE: 35,
		GlobalEnums.CardRarity.LEGENDARY: 15
	}
	
	if node.type == GlobalEnums.MapNodeType.ELITE:
		rarity_weights[GlobalEnums.CardRarity.COMMON] -= 20
		rarity_weights[GlobalEnums.CardRarity.RARE] += 20
	elif node.type == GlobalEnums.MapNodeType.BOSS:
		rarity_weights[GlobalEnums.CardRarity.COMMON] -= 50
		rarity_weights[GlobalEnums.CardRarity.RARE] += 25
		rarity_weights[GlobalEnums.CardRarity.LEGENDARY] += 25
	
	var relic = _pick_relic(rarity_weights)
	if relic:
		RunState.relics_offered.append(relic)
		relic_button.text = relic.relic_name
		relic_button.visible = true
	else:
		relic_button.visible = false

func _pick_relic(weights: Dictionary) -> RelicData:
	var total = 0
	for w in weights.values():
		total += w
	var roll = RunState.rng.randi_range(0, total - 1)
	var cumulative = 0
	
	for rarity in weights:
		cumulative += weights[rarity]
		if roll < cumulative:
			var relics = RelicLibrary.get_relics_by_rarity(rarity)
			if relics.is_empty():
				return null
			return relics[RunState.rng.randi_range(0, relics.size() - 1)]
	return null

@onready var gold_button: Button = $Rewards/slot/GoldButton

func offer_gold() -> void:
	if RunState.gold_accepted:
		gold_button.queue_free()
		return
	
	var node = RunState.map_data.get_current_node()
	var base_gold: int = 0
	var enemy_gold: int = 0
	
	# Room type modifier
	match node.type:
		GlobalEnums.MapNodeType.COMBAT:
			base_gold = 30 + (5 * RunState.current_floor)
		GlobalEnums.MapNodeType.ELITE:
			base_gold = 100 + (10 * RunState.current_floor)
		GlobalEnums.MapNodeType.BOSS:
			base_gold = 250 + (20 * RunState.current_floor)
	
	# Enemy gold drops
	if node.encounter:
		for enemy_data in node.encounter.enemies:
			enemy_gold += enemy_data.gold_drop
	
	gold = base_gold + enemy_gold
	if gold == 0:
		gold_button.queue_free()
		return
	else:
		gold_button.text = str(gold, " Gold")
	RunState.gold_offered = gold

func offer_cards():
	if RunState.cards_generated:
		for card in RunState.cards_offered:
			_offer_card(card)
		return

	for i in range(RunState.card_choices):
		var card_data = pick_card().duplicate(true)
		card_data.uid = CardLibrary.get_next_uid()  # ← assign UID first
		_offer_card(card_data)                       # ← then instantiate with correct UID
		RunState.cards_offered.append(card_data)

	cards_offered = RunState.cards_offered
	RunState.cards_generated = true

func get_rarity_weights(node_type: GlobalEnums.MapNodeType) -> Dictionary:
	var weights = {
		GlobalEnums.CardRarity.COMMON: 60,
		GlobalEnums.CardRarity.RARE: 30,
		GlobalEnums.CardRarity.LEGENDARY: 10
	}
	if node_type == GlobalEnums.MapNodeType.ELITE:
		weights[GlobalEnums.CardRarity.COMMON] -= 30
		weights[GlobalEnums.CardRarity.RARE] += 20
		weights[GlobalEnums.CardRarity.LEGENDARY] += 10
	
	elif node_type == GlobalEnums.MapNodeType.BOSS:
		weights[GlobalEnums.CardRarity.COMMON] -= 60
		weights[GlobalEnums.CardRarity.RARE] += 30
		weights[GlobalEnums.CardRarity.LEGENDARY] += 30
	return weights

func pick_card() -> CardData:
	#TODO Animation
	#TODO Ensure no duplicate cards; if card already selected reroll until unselected card found
	#TODO add check based on a runstate variable if maximum cards recieved have been hit; if so remove option for selecting cards; initalized to 1 option
	#TODO add runstate  variable for number of card choices
	var card_rarity_weights: Dictionary = get_rarity_weights(RunState.map_data.get_current_node().type)
	
	var card : CardData
	var card_rarity_rng = RunState.rng.randi_range(0,100)
	var card_choices: Array[CardData]
	if card_rarity_rng < card_rarity_weights[GlobalEnums.CardRarity.LEGENDARY]:
		card_choices= CardLibrary.get_cards_by_rarity(GlobalEnums.CardRarity.LEGENDARY)
	elif card_rarity_rng < card_rarity_weights[GlobalEnums.CardRarity.RARE]:
		card_choices= CardLibrary.get_cards_by_rarity(GlobalEnums.CardRarity.RARE)
	else:
		card_choices= CardLibrary.get_cards_by_rarity(GlobalEnums.CardRarity.COMMON)
	#TODO Based on encounter weight certain colors over others; enemies are from certain factions; 
	# you can kinda route wtih them in mind, or also spawn them in groups; keeping a single faction together spanning multiple levels and connections
	# say cleave half of all other colors at this point
	
	#card from choices RNG
	var card_rng = RunState.rng.randi_range(0,card_choices.size()-1)
	card = card_choices[card_rng]
	return card

func on_card_chosen(card: CardData) -> void:
	var copy = card.duplicate()
	copy.uid = CardLibrary.get_next_uid()
	RunState.deck.append(copy)
	cards_offered.erase(card)
	RunState.cards_offered = cards_offered
	RunState.cards_accepted += 1
	if RunState.cards_accepted >= RunState.max_accepted_cards:
		_clear_cards()
		return
	for child in card_container.get_children():
		if child.card_data.uid == card.uid:
			child.queue_free()
			break
	selected_card = null 

func _clear_cards():
	card_container.queue_free()

func _offer_card(card_data:CardData) -> CardData:
	var card = CARD_SCENE.instantiate()
	card.clicked.connect(_on_card_clicked)
	card_container.add_child(card)
	card.setup(card_data)
	return card_data

func _on_card_clicked(card: Card) -> void:
	
	select_card(card.card_data)

var selected_card :CardData = null

func select_card(card: CardData) -> void:
	if selected_card == null:
		selected_card = card
		_raise_selected_card(card)
		return
	if selected_card.uid == card.uid:
		confirm_selection(card)
		return
	else:
		selected_card = card
		_raise_selected_card(card)

func _reset_card_positions() -> void:
	for child in card_container.get_children():
		child.position.y = 0

func _raise_selected_card(card: CardData) -> void:
	_reset_card_positions()
	for child in card_container.get_children():
		if child.card_data.uid == card.uid:
			child.position.y = -30
			break

func confirm_selection(card: CardData) -> void:
	if selected_card == null:
		return
	if selected_card == card:
		on_card_chosen(card)

func _on_gold_button_pressed() -> void:
	RunState.gold += gold
	RunState.gold_offered = 0
	RunState.gold_accepted = true
	gold_button.queue_free()

func _on_relic_button_pressed() -> void:
	if RunState.relics_offered.is_empty():
		relic_button.queue_free()
		return
	
	var relic = RunState.relics_offered[0]
	RunState.relics.append(relic)
	relic.on_collected.call()
	RunState.relic_accepted = true
	relic_button.queue_free()


func _on_map_button_pressed() -> void:
	RunState.push_scene("res://Scenes/MapManager.tscn")

const DECK_VIEWER = preload("res://Scenes/DeckViewer.tscn")
func _on_deck_button_pressed() -> void:
	var viewer = DECK_VIEWER.instantiate()
	viewer.init(RunState.deck, "Deck")
	add_child(viewer)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
