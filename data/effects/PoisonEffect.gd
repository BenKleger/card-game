# effects/EffectPoison.gd
class_name EffectPoison
extends Effect

func _init() -> void:
	name = "Poison"
	description = "Take damage at start of turn"
	proc_on = GlobalEnums.ProcOn.TURN_END
	is_debuff = true

func proc(owner: Node, from: Node = null) -> void:
	from.current_hp -= stacks
	from.update_stats()
