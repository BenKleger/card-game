extends Control

#TODO Dynamically add and remove text boxes to $VBoxContainer/ChatHBC/ResponseContainer


func _ready() -> void:
	pass

func _on_continue_pressed() -> void:
	RunState.map_data.get_current_node().cleared = true
	RunState.scene_history.clear()
	RunState.push_scene("res://Scenes/MapManager.tscn")
