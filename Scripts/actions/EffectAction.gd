class_name EffectAction
extends CombatAction

@export var effect:Effect = null
@export var amount: int = 0
@export var amount_upgrade: int = 0

func upgrade():
	if effect:
		effect.stacks += amount_upgrade
