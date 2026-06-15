# effects/EffectPoison.gd
class_name EffectPoison
extends Effect

func _init() -> void:
	name = "Poison"
	description = "Take damage at start of turn"
	proc_on = GlobalEnums.ProcOn.TURN_END
	is_debuff = true

func on_applied(owner):
	owner.current_hp -= stacks

func proc(owner: Node, _from: Node = null) -> void:
	owner.current_hp -= stacks
	owner.update_stats()
