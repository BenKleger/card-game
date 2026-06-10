extends CanvasLayer

const CARD_SCENE = preload("res://Scenes/Card.tscn")
@onready var title: Label = $PanelContainer/VBoxContainer/VBoxContainer/Label
@onready var grid: GridContainer = $PanelContainer/VBoxContainer/ScrollContainer/CenterContainer/GridContainer
var _cards: Array[CardData] = []
var _title: String = ""

enum SortMode { COST, COLOR, RARITY }
var sort_mode: SortMode = SortMode.COST

@onready var sort_button: Button = $PanelContainer/VBoxContainer/VBoxContainer/SortButton

var upgrade_menu = false
#TODO if upgrade menu; set up cards as clickable in ready; spawn gui upon clicking a card; showing upgraded variant, option to confirm or cancel the card being upgrade; also to 
# cancel the upgrade separately; maybe in all deckviewer menus make the view upgraded card with cancel always available, but only upgrade button if upgrade_menu =true
# also ensure that once the upgrade is pressed the menu is closed and the option to upgrade at rest_site perhaps setup in runstate is taken; also 
#TODO make sure that off spawn you get limited rest site options; creating a runstate variable that defines the number of upgrade options and graying out all remaining options once the number has been hit


func _populate() -> void:
	title.text = _title + " — " + str(_cards.size()) + " cards"
	for child in grid.get_children():
		child.queue_free()
	var sorted = _sort_cards(_cards.duplicate())
	for card_data in sorted:
		var card = CARD_SCENE.instantiate()
		card.setup(card_data)
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		grid.add_child(card)
		card.size = Vector2(120, 160)
	sort_button.text = "Sort: " + SortMode.keys()[sort_mode].capitalize()

func _sort_cards(cards: Array) -> Array:
	match sort_mode:
		SortMode.COST:
			cards.sort_custom(func(a, b): 
				if a.energy_cost != b.energy_cost:
					return a.energy_cost < b.energy_cost
				return a.color < b.color)
		SortMode.COLOR:
			cards.sort_custom(func(a, b):
				if a.color != b.color:
					return a.color < b.color
				return a.energy_cost < b.energy_cost)
		SortMode.RARITY:
			cards.sort_custom(func(a, b):
				if a.rarity != b.rarity:
					return a.rarity > b.rarity  # legendary first
				return a.energy_cost < b.energy_cost)
	return cards

func _on_sort_button_pressed() -> void:
	sort_mode = (sort_mode + 1) % SortMode.size()
	_populate()

func init(cards: Array[CardData], viewer_title: String) -> void:
	_cards = cards
	_title = viewer_title

	
func _ready() -> void:
	print("DeckViewer ready, cards: ", _cards.size(), " grid: ", grid)
	_populate()


signal close_requested

func _on_close_button_pressed() -> void:
	close_requested.emit()
	queue_free()
