# effects/EffectStrength.gd
class_name EffectStrength
extends Effect

func _init() -> void:
	name = "Strength"
	description = "Increases attack damage"
	proc_on = GlobalEnums.ProcOn.TURN_START
	is_debuff = false

func proc(_owner: Node, _from: Node = null) -> void:
	pass  # Checked in _attack_target
