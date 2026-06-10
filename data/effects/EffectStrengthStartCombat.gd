class_name EffectStrengthStartCombat
extends Effect

func _init() -> void:
	name = "StrengthStartCombat"
	description = "Gain strength at combat start"
	proc_on = GlobalEnums.ProcOn.START_COMBAT

func proc(owner: Node, from: Node = null) -> void:
	var strength = EffectStrength.new()
	strength.stacks = stacks
	# Apply to owner
	for existing in owner.effects:
		if existing is EffectStrength:
			existing.stacks += strength.stacks
			return
	owner.effects.append(strength)
	owner.update_stats()
	reduce_stacks(owner)
