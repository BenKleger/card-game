#ActionLibrary.gd
extends Node

func generate_description(actions: Array[CombatAction]) -> String:
	var desc := ""
	for action in actions:
		pass
		match action.target_type:
			GlobalEnums.TargetType.SINGLE_ENEMY:
				if action is KillAction:
					desc += "Kill Enemy" +"\n"
					continue
				elif action is EffectAction:
					desc += str(action.effect.stacks)
				else:
					desc +=  str(action.amount) 
				desc += " " +get_action_string(action)+" to an Enemy" +"\n"
			GlobalEnums.TargetType.SINGLE_ALLY:
				if action is KillAction:
					desc +=  "Kill Ally" +"\n"
					continue
				elif action is EffectAction:
					desc += str(action.effect.stacks)
				else:
					desc +=  str(action.amount) 
				desc += " " +get_action_string(action)+" to an Ally" +"\n"
			GlobalEnums.TargetType.SELF:
				if action is KillAction:
					desc +=  "Kill Self" +"\n"
					continue
				elif action is EffectAction:
					desc += str(action.effect.stacks)
				else:
					desc +=  str(action.amount) 
				desc += " " +get_action_string(action) +" to Self" +"\n"
			GlobalEnums.TargetType.ALL_ALLIES:
				if action is KillAction:
					desc +=  "Kill All Allies" +"\n"
					continue
				elif action is EffectAction:
					desc += str(action.effect.stacks)
				else:
					desc +=  str(action.amount) 
				desc += " " +get_action_string(action)+ " to all Allies" +"\n"
			GlobalEnums.TargetType.ALL_ENEMIES:
				if action is KillAction:
					desc +=  "Kill All Enemies" +"\n"
					continue
				elif action is EffectAction:
					desc += str(action.effect.stacks)
				else:
					desc +=  str(action.amount) 
				desc += " " +get_action_string(action)+ " to all Enemies" +"\n"
			
			GlobalEnums.TargetType.PLAYER:
				if action is KillAction:
					desc +=  "Kill Player" +"\n"
					continue
				elif action is EffectAction:
					desc += str(action.effect.stacks)
				else:
					desc +=  str(action.amount) 
				desc += " " + get_action_string(action)+" to Player" +"\n" #TODO Change from player?
			GlobalEnums.TargetType.SUMMON_ALLY:
				if action is SummonAction:
					desc+= "Summon " + action.summon_data.summon_name +"\n"
	return desc

func get_action_string(action:CombatAction)-> String:
	@warning_ignore("shadowed_global_identifier")
	var str = ""
	if action is DamageAction:
		str = "Damage"
	elif action is BlockAction:
		str = "Block"
	elif action is DrawAction:
		str = "Draw"
	elif action is CoinAction:
		str = "Coin"
	elif action is EffectAction:
		str = action.effect.name
	elif action is SummonAction:
		str = "Summon" + action.summon_data.summon_name # perhaps do something like generate_description(action.summon_data.actions) #perhaps linking a preview of summon but thats later #TODO
	elif action is GainEnergyAction:
		str = "Energy Gain"
	elif action is HealAction:
		str = "Heal"
	else:
		str = "?"
	return str
