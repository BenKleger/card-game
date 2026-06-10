extends Control

const REST_HEAL_PERCENT := 0.30

func _on_continue_pressed() -> void:
	RunState.map_data.get_current_node().cleared = true
	RunState.scene_history.clear()
	RunState.push_scene("res://Scenes/MapManager.tscn")

#TODO Dynamically add buttons; option to press multiple buttons based on relic-->runstate; ready: run some if runstate.x: checks

func _on_rest_pressed() -> void:
	var heal_amount := int(RunState.max_hp * RunState.rest_heal_percent)

	RunState.current_hp = min(
		RunState.current_hp + heal_amount,
		RunState.max_hp
	)
func _on_upgrade_pressed()->void:
	pass
	
