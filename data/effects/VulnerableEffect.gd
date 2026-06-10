# effects/EffectVulnerable.gd
class_name EffectVulnerable
extends Effect

func _init() -> void:
	name = "Vulnerable"
	description = "Takes 50% more damage"
	proc_on = GlobalEnums.ProcOn.TURN_END
	is_debuff = true

func proc(owner: Node, from: Node = null) -> void:
	reduce_stacks(owner)
