# effects/EffectBurn.gd
class_name EffectBurn
extends Effect

func _init() -> void:
	name = "Burn"
	description = "Take Damage At End of Turn"
	proc_on = GlobalEnums.ProcOn.TURN_END
	is_debuff = true

func proc(owner: Node, _from: Node = null) -> void:
	owner.current_hp -= stacks
	reduce_stacks(owner, 1)
	owner.update_stats()
