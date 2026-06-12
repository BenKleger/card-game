# effects/EffectThorns.gd
class_name EffectThorns
extends Effect

func _init() -> void:
	name = "Thorns"
	description = "Attackers lose health"
	proc_on = GlobalEnums.ProcOn.ON_HP_DAMAGED
	is_debuff = true

func proc(owner: Node, from: Node = null) -> void:
	from.current_hp -= stacks
	from.update_stats()
