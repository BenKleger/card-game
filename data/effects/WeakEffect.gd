# effects/EffectWeak.gd
class_name EffectWeak
extends Effect

func _init() -> void:
	name = "Weak"
	description = "Reduces attack damage by 25%"
	proc_on = GlobalEnums.ProcOn.TURN_END
	is_debuff = true

func proc(owner: Node, _from: Node = null) -> void:
	reduce_stacks(owner,1)
