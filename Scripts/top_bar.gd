# TopBar.gd
extends CanvasLayer

@onready var floor_label: Label = $PanelContainer/VBoxContainer/HBoxContainer/FloorLabel
@onready var hp_label: Label = $PanelContainer/VBoxContainer/HBoxContainer/HPLabel
@onready var gold_label: Label = $PanelContainer/VBoxContainer/HBoxContainer/GoldLabel
@onready var deck_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/DeckButton
@onready var map_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/MapButton
@onready var relics_container: HBoxContainer = $PanelContainer/VBoxContainer/RelicContainer
@onready var escape_menu_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/EscapeMenuButton

const DECK_VIEWER = preload("res://Scenes/DeckViewer.tscn")

func _ready() -> void:
	update_display()

func _process(_delta: float) -> void:
	update_display()

func update_display() -> void:
	floor_label.text = "Floor: " + str(RunState.current_floor)
	gold_label.text = "Gold: " + str(RunState.gold)
	map_button.disabled = RunState.current_scene_path() == "res://Scenes/MapManager.tscn"
	_update_relics_display()

func _update_relics_display() -> void:
	for child in relics_container.get_children():
		child.queue_free()
		
	for relic in RunState.relics:
		var label = Label.new()
		label.text = relic.relic_name.substr(0, 3).to_upper()
		label.tooltip_text = relic.description
		relics_container.add_child(label)

const MAP_VIEWER = preload("uid://bibusaeim3nxb")

var map_open: bool = false

func _on_map_button_pressed() -> void:
	RunState.open_map_viewer(get_tree().root)



const ESCAPE_VIEWER = preload("res://Scenes/escape_menu.tscn")

func _on_escape_menu_button_pressed() -> void:
	RunState.open_escape_menu(self)

func _on_deck_button_pressed() -> void:
	RunState.open_deck_viewer(get_tree().root, RunState.deck, "Deck")
