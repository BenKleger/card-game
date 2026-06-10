# effects/EffectWeak.gd
class_name EffectWeak
extends Effect

func _init() -> void:
	name = "Weak"
	description = "Reduces attack damage by 25%"
	proc_on = GlobalEnums.ProcOn.ON_ATTACK
	is_debuff = true

func proc(owner: Node, from: Node = null) -> void:
	# Weak is checked in _attack_target, not here
	# This proc fires to reduce stacks at end of turn
	pass
