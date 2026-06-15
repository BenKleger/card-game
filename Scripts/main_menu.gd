extends Control

func _ready():
	if RunState.current_scene_path() == "":
		$VBoxContainer/ContinueButton.queue_free()
	#TODO check if current run is active and remove continue button if not done??

func _on_start_button_pressed() -> void:
	RunState.new_run()
	RunState.open_top_bar(get_tree().root)
	RunState.push_scene("res://Scenes/MapManager.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_continue_button_pressed() -> void:
	RunState.open_top_bar(get_tree().root)
	RunState.rng.set_state(RunState.rng_state)
	if RunState.current_scene_path() != "":
		get_tree().change_scene_to_file(RunState.current_scene_path())
