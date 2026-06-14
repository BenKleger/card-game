# effects/EffectBleed.gd
class_name EffectBleed
extends Effect

func _init() -> void:
	name = "Bleed"
	description = "Lose HP at start of turn"
	proc_on = GlobalEnums.ProcOn.TURN_START
	is_debuff = true

func proc(owner: Node, _from: Node = null) -> void:
	owner.current_hp -= stacks
	owner.update_stats()
	
	reduce_stacks(owner,stacks/2 if stacks>1 else 1)
