extends Control

const REST_HEAL_PERCENT := 0.30

func _on_continue_pressed() -> void:
	RunState.map_data.get_current_node().cleared = true
	RunState.scene_history.clear()
	RunState.push_scene("res://Scenes/MapManager.tscn")

#TODO Dynamically add buttons; option to press multiple buttons based on relic-->runstate; ready: run some if runstate.x: checks

enum choice_type {REST, UPGRADE}

@onready var rest: Button = $VBoxContainer/Options/Rest
@onready var upgrade: Button = $VBoxContainer/Options/Upgrade
var choices_taken:int = 0


func _choice_taken(choice:choice_type):
	match choice:
		choice_type.REST:
			rest.queue_free()
		choice_type.UPGRADE:
			upgrade.queue_free()
		_:
			pass
	choices_taken+=1
	if choices_taken>=RunState.choices_per_rest:
		lock_all_choices()
		
@onready var options: HBoxContainer = $VBoxContainer/Options

func lock_all_choices():
	for child in options.get_children():
		print(child)
		child.queue_free()

func _on_rest_pressed() -> void:
	var heal_amount := int(RunState.max_hp * RunState.rest_heal_percent)

	RunState.current_hp = min(
		RunState.current_hp + heal_amount,
		RunState.max_hp
	)
	_choice_taken(choice_type.REST)
	
func _on_upgrade_pressed()->void:
	RunState.upgrades_available += 1
	_choice_taken(choice_type.UPGRADE)
	
