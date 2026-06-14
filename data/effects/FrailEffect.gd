class_name EffectFrail
extends Effect

func _init() -> void:
	name = "Frail"
	description = "Gain less block."
	proc_on = GlobalEnums.ProcOn.TURN_END
	is_debuff = true
	
func proc(owner: Node, _from: Node = null) -> void:
	reduce_stacks(owner)
