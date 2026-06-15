extends Node


var scene_history: Array[String] = []
var map_data: MapData = null
var deck: Array[CardData] = []
var gold: int = GlobalConstants.STARTING_GOLD
var current_hp: int = GlobalConstants.STARTING_HP
var max_hp: int = GlobalConstants.STARTING_HP
var max_hand_size : int = GlobalConstants.MAX_HAND_SIZE
var max_energy: int = GlobalConstants.BASE_ENERGY
var block_clear: bool = GlobalConstants.BASE_BLOCK_CLEAR
var card_choices: int = GlobalConstants.CARD_CHOICES
var card_draw:int = GlobalConstants.CARD_DRAW
var current_floor:int = 0
var relics: Array = [] # set up to be an array of Relics TODO
var rng := RandomNumberGenerator.new()
var rng_state = rng.get_state()

# Offerings Data
var max_accepted_cards:int = 1
var gold_offered: int = 0
var gold_accepted: bool = false
var cards_offered: Array[CardData] = []
var cards_generated: bool = false
var cards_accepted: int = 0
var relics_offered: Array[RelicData] = []
var relic_accepted: bool = false

var deck_viewer: CanvasLayer = null

#Rest site stuff
var rest_heal_percent: float = 0.3
var upgrades_available: int = 0
var ui_locked: bool = false
var choices_per_rest: int = 1

#Shop stuff
var shop_generated:bool = false
var shop_cards:Array[CardData]= []
var shop_relics:Array[RelicData] = []

#TODO Relic / Effect Connections###
var card_energy_reduction: int = 0
var damage_reduction: int = 0
var starting_strength: int = 0
var enemy_bleed_reduction: int = 0
var block_pierce: int = 0
var gold_per_kill: int = 0
var look_ahead_turns: int = 1
var enemy_miss_chance: float = 0.0
var rewind_available: bool = false
var death_save_available: bool = false
var feast_threshold: int = 0
var weak_on_play: bool = false
var escape_viewer: CanvasLayer = null
var map_viewer: Node2D = null
var top_bar: CanvasLayer = null


func open_top_bar(parent: Node) -> void:
	if top_bar != null:
		return
	top_bar = preload("res://Scenes/TopBar.tscn").instantiate()
	parent.add_child(top_bar)

func open_deck_viewer(parent: Node, cards: Array[CardData], title: String) -> void:
	if deck_viewer != null:
		deck_viewer = null
		_set_top_bar_visible(true)
	deck_viewer = preload("res://Scenes/DeckViewer.tscn").instantiate()
	deck_viewer.init(cards, title)
	parent.add_child(deck_viewer)
	_set_top_bar_visible(false)
	deck_viewer.close_requested.connect(func():
		deck_viewer = null
		_set_top_bar_visible(true)
	)

func open_map_viewer(parent: Node) -> void:
	if map_viewer != null:
		map_viewer.queue_free()
		map_viewer = null

	map_viewer = preload("res://Scenes/MapManager.tscn").instantiate()
	map_viewer.preview_mode = true

	parent.add_child(map_viewer)

	map_viewer.close_requested.connect(func():
		map_viewer.queue_free()
		map_viewer = null
	)

func open_escape_menu(parent: Node) -> void:
	if escape_viewer != null:
		escape_viewer.queue_free()
		escape_viewer = null
	escape_viewer = preload("res://Scenes/escape_menu.tscn").instantiate()
	parent.add_child(escape_viewer)
	escape_viewer.close_requested.connect(func():
		escape_viewer.queue_free()
		escape_viewer = null
	)

func _set_top_bar_visible(visible: bool) -> void:
	for child in get_tree().root.get_children():
		if child is CanvasLayer and child.name == "TopBar":
			child.visible = visible
			break

func cleanup_overlays() -> void:    
	if top_bar != null:
		top_bar.queue_free()
		top_bar = null
	if map_viewer != null:
		map_viewer.queue_free()
		map_viewer = null
	if deck_viewer != null:
		deck_viewer.queue_free()
		deck_viewer = null
	if escape_viewer != null:
		escape_viewer.queue_free()
		escape_viewer = null

func clear_rewards():
	gold_offered = 0
	gold_accepted = false
	cards_offered = []
	cards_generated = false
	relics_offered = []
	relic_accepted = false
	cards_accepted = 0

func push_scene(path: String) -> void:
	scene_history.append(path)
	get_tree().change_scene_to_file(path)

func pop_scene() -> void:
	if scene_history.size() > 1:
		scene_history.pop_back()  # remove current
		get_tree().change_scene_to_file(scene_history.back())

func current_scene_path() -> String:
	if scene_history.is_empty():
		return ""
	return scene_history.back()

func _input(event:InputEvent):
	if event.is_action_released("ui_cancel"):
		open_escape_menu(get_tree().root)

func new_run(run_seed: int = randi()) -> void:
	rng.seed = run_seed
	gold = GlobalConstants.STARTING_GOLD
	current_hp = GlobalConstants.STARTING_HP
	max_hp = GlobalConstants.STARTING_HP
	max_energy = GlobalConstants.BASE_ENERGY
	card_draw = GlobalConstants.CARD_DRAW
	card_choices = GlobalConstants.CARD_CHOICES
	max_hand_size = GlobalConstants.MAX_HAND_SIZE
	deck = []
	relics = []
	map_data = null
	current_floor = 0
	
	clear_rewards()
	_create_map()
	_generate_starting_deck()


func _create_map():
	map_data = MapData.new()
	map_data.generate(rng)
func _generate_starting_deck():
	var strike = CardLibrary.all_cards[0]
	var defend = CardLibrary.all_cards[1]
	for i in 5:
		var copy = strike.duplicate(true)
		copy.uid = CardLibrary.get_next_uid()
		deck.append(copy)
		var defcopy = defend.duplicate(true)
		defcopy.uid = CardLibrary.get_next_uid()
		deck.append(defcopy)
