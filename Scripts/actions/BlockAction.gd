class_name BlockAction
extends CombatAction

@export var amount: int = 0
@export var amount_upgrade: int = 0

func upgrade():
	amount += amount_upgrade
