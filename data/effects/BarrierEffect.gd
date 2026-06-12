class_name EffectBarrier
extends Effect

func _init() -> void:
	name = "Barrier"
	description = "Permanent block."
	proc_on = GlobalEnums.ProcOn.NONE

func on_applied(owner: Node) -> void:
	owner.permanent_block += stacks
