class_name SummonAction
extends CombatAction

@export var summon_data: SummonData = null

func upgrade():
	for action in summon_data.actions:
		action.upgrade()
	summon_data.summon_name += "+"
