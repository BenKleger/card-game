# effects/EffectRegen.gd
class_name EffectRegen
extends Effect

func _init() -> void:
	name = "Regen"
	description = "Recover HP at start of turn"
	proc_on = GlobalEnums.ProcOn.TURN_START
	is_debuff = false

func proc(owner: Node, _from: Node = null) -> void:
	owner.current_hp = min(owner.current_hp + stacks, owner.max_hp)
	owner.update_stats()
	reduce_stacks(owner)
