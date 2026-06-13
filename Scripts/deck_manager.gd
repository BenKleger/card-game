class_name DeckManager
extends Node

var draw_pile: Array[CardData] = []
var discard_pile: Array[CardData] = []
var exhaust_pile: Array[CardData] = []
static var hand: Array[CardData] = []
var summons: Array[CardData] = []

func initialize(deck: Array[CardData]) -> void:
	draw_pile = []
	for card in deck:
		var copy = card.duplicate()
		copy.uid = CardLibrary.get_next_uid()
		draw_pile.append(copy)
	discard_pile = []
	shuffle_draw_pile()

const UpgradePreviewScene = preload("uid://bcoxgpf2uhxyf")

func _on_card_clicked(card: CardData) -> void:
	var preview = UpgradePreviewScene.instantiate()
	add_child(preview)

	preview.open(card)

	preview.confirmed.connect(_apply_upgrade)

func _apply_upgrade(card: CardData) -> void:
	if RunState.upgrades_available <= 0:
		return
	card.upgrade()
	RunState.upgrades_available -= 1
	
func get_draw_count() -> int:
	return draw_pile.size()
	
func get_discard_count() -> int:
	return discard_pile.size()

func get_exhaust_count() -> int:
	return exhaust_pile.size()

func draw(n: int) -> Array[CardData]:
	var drawn: Array[CardData] = []
	for i in n:
		if draw_pile.is_empty():
			if discard_pile.is_empty():
				break
			refill_draw_pile()
		drawn.append(draw_pile.pop_back())
	return drawn
	
func discard(card: CardData) -> void:
	discard_pile.append(card)

func exhaust(card:CardData)-> void:
	exhaust_pile.append(card)

func refill_draw_pile() -> void:
	draw_pile.append_array(discard_pile)
	discard_pile.clear()
	shuffle_draw_pile()

func shuffle_draw_pile() -> void:
	#TODO add some form of animation
	for i in range(draw_pile.size() - 1, 0, -1):
		var j = RunState.rng.randi_range(0, i)
		var temp = draw_pile[i]
		draw_pile[i] = draw_pile[j]
		draw_pile[j] = temp
