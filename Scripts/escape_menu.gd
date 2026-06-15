# EscapeMenu.gd
extends CanvasLayer

@onready var container: Control = $VBoxContainer
signal close_requested #check map TODO

func _ready() -> void:
	$VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$VBoxContainer/ExitRunButton.pressed.connect(_on_exit_run_pressed)
	$VBoxContainer/AbandonRunButton.pressed.connect(_on_abandon_run_pressed)
	container.visible = true

func _on_resume_pressed() -> void:
	close_requested.emit()

func _on_settings_pressed() -> void:
	# TODO settings
	pass

func _on_exit_run_pressed() -> void:
	close_requested.emit()
	RunState.cleanup_overlays()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_abandon_run_pressed() -> void:
	close_requested.emit()
	RunState.new_run()
	RunState.cleanup_overlays()
	RunState.scene_history.clear()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
