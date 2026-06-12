class_name CombatEffects
extends Node


static func proc_effects(creature: Node, proc_on: GlobalEnums.ProcOn, from: Node = null) -> void:
	for effect in creature.effects:
		if effect.proc_on == proc_on:
			effect.proc(creature, from)
			creature.update_stats()

static func apply_effect(effect: Effect, target: Node) -> void:
	# Check if effect of same type already exists — add stacks
	for existing in target.effects:
		if existing.get_script() == effect.get_script():
			existing.stacks += effect.stacks
			return
	# Otherwise add fresh
	var new_effect = effect.duplicate()
	target.effects.append(new_effect)
	new_effect.on_applied(target)

static func gain_block(target: Node, amount: int) -> void:
	var final_amount = amount
	var frail :EffectFrail= target.get_effect(EffectFrail)
	if frail:
		final_amount = floor(final_amount * 0.75)
	target.block += final_amount

static func resolve_action(
	source: Node,
	targets: Array,
	damage: int,
	block: int,
	target_effects: Array[Effect],
	self_effects: Array[Effect] = []
) -> void:

	for target in targets:
		if damage > 0:
			attack_target(damage, target, source)
		if block > 0:
			gain_block(target,block)
		apply_target_effects(target,target_effects)
		target.update_stats()
	apply_source_effects(source, self_effects)
	source.update_stats()

static func apply_target_effects(
	target: Node,
	target_effects: Array[Effect]
):
	for effect in target_effects:
		apply_effect(effect.duplicate(), target)
		
static func apply_source_effects(
	source: Node,
	self_effects: Array[Effect]
):
	
	for effect in self_effects:
		apply_effect(effect.duplicate(), source)
	
static func attack_target(damage:int, target:Node, source: Node)->void:
	#Str
	for effect in source.effects:
		if effect is EffectStrength:
			damage += effect.stacks
			break 
			
		# Weak — source deals less damage
	for effect in source.effects:
		if effect is EffectWeak:
			damage = int(damage * 0.75)
			break
	
	# Vulnerable — target takes more damage
	for effect in target.effects:
		if effect is EffectVulnerable:
			damage = int(damage * 1.5)
			break
			
	if target.block == 0:
		proc_effects(target, GlobalEnums.ProcOn.ON_HP_DAMAGED, source)
		target.current_hp -= damage
	elif target.block < damage:
		proc_effects(target, GlobalEnums.ProcOn.ON_SHIELD_DAMAGED, source)
		proc_effects(target, GlobalEnums.ProcOn.ON_HP_DAMAGED, source)
		#TODO Add animation
		var block_damage:int = target.block
		target.block = 0
		#TODO Add animation
		target.current_hp -= (damage-block_damage)
	else: #Target fully blocks
		#TODO Add animation
		target.block -= damage
	proc_effects(target, GlobalEnums.ProcOn.ON_ATTACK,source)
