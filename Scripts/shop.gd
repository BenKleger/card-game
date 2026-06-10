extends Control

@export var scene_name: String = "Shop"

func _ready() -> void:
	$Label.text = "Shop"
	#TODO

func _pick_shop_cards():
	pass
	#TODO use already made architecture for cards; different rarity calculations
	#TODO also do all the shop bullshit; create a deck button in there; do some form of cards being sold by type; maybe some relics being sold
	#TODO make relics :)

func _on_continue_pressed() -> void:
	RunState.map_data.get_current_node().cleared = true
	RunState.scene_history.clear()
	RunState.push_scene("res://Scenes/MapManager.tscn")
