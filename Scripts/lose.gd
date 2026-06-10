extends Control

func _ready() -> void:
	$VBoxContainer/StatsLabel.text = "Floor reached: " + str(RunState.current_floor) + "\nGold: " + str(RunState.gold)

func _on_retry_button_pressed() -> void:
	RunState.new_run()
	RunState.push_scene("res://Scenes/MapManager.tscn")

func _on_main_menu_button_pressed() -> void:
	RunState.new_run()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
