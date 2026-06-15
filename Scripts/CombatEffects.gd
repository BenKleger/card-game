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
			effect.on_applied(target)
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

static func execute_action(
	source:Node,
	targets:Array,
	action:CombatAction
):
	if action is DamageAction:
		for target in targets:
			attack_target(
				action.amount,
				target,
				source
			)

	elif action is BlockAction:
		for target in targets:
			gain_block(
				target,
				action.amount
			)

	elif action is EffectAction:
		for target in targets:
			apply_effect(
				action.effect,
				target
			)

	elif action is KillAction:
		for target in targets:
			target.current_hp = 0 

	elif action is CoinAction:
		pass #gain coin
	
	elif action is HealAction:
		for target in targets:
			target.current_hp = min(target.max_hp, target.current_hp + action.amount)
	
	else:
		print("WTF?")

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
	var target_block: int = target.block
	
	if(target.block>0):
		proc_effects(target, GlobalEnums.ProcOn.ON_SHIELD_DAMAGED, source)
		target.block = max(target.block-damage,0)
		#TODO Add animation
	
	if damage-target_block>0:
		proc_effects(target, GlobalEnums.ProcOn.ON_HP_DAMAGED, source)
		target.current_hp -= damage-target_block
		#TODO Add animation
	
	proc_effects(target, GlobalEnums.ProcOn.ON_ATTACK,source)
