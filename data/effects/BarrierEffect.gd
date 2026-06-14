class_name EffectBarrier
extends Effect

func _init() -> void:
	name = "Barrier"
	description = "Gain block at turn start"
	proc_on = GlobalEnums.ProcOn.NONE

func on_applied(owner: Node) -> void:
	owner.permanent_block += stacks
