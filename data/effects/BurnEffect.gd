# effects/EffectBurn.gd
class_name EffectBurn
extends Effect

func _init() -> void:
	name = "Burn"
	description = "Take Damage At End of Turn"
	proc_on = GlobalEnums.ProcOn.TURN_END
	is_debuff = true

func proc(owner: Node, from: Node = null) -> void:
	from.current_hp -= stacks
	reduce_stacks(owner, 1)
	from.update_stats()
