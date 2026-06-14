class_name AF #ActionFactory
extends Node

static func damage(target_type, amount: int, upgrade: int = 0) -> DamageAction:
	var a := DamageAction.new()
	a.target_type = target_type
	a.amount = amount
	a.amount_upgrade = upgrade
	return a

static func block(target_type, amount: int, upgrade: int = 0) -> BlockAction:
	var a := BlockAction.new()
	a.target_type = target_type
	a.amount = amount
	a.amount_upgrade = upgrade
	return a

static func heal(target_type, amount: int, upgrade: int = 0) -> HealAction:
	var a := HealAction.new()
	a.target_type = target_type
	a.amount = amount
	a.amount_upgrade = upgrade
	return a

static func effect(target_type, effect:Effect, upgrade:int = 0)->EffectAction:
	var a := EffectAction.new()
	a.target_type = target_type
	a.effect = effect
	a.amount_upgrade = upgrade
	return a

static func gain_energy(target_type, amount: int, upgrade:int=0)-> GainEnergyAction:
	var a := GainEnergyAction.new()
	a.target_type = target_type
	a.amount = amount
	a.amount_upgrade = upgrade
	return a

static func summon(target_type,summon_data:SummonData)-> SummonAction:
	var a := SummonAction.new()
	a.target_type = target_type
	a.summon_data=summon_data
	return a

static func kill(target_type)-> KillAction:
	var a := KillAction.new()
	a.target_type = target_type
	return a

static func draw(target_type, amount:int, upgrade:int=0)-> DrawAction:
	var a := DrawAction.new()
	a.target_type = target_type
	a.amount = amount
	a.amount_upgrade = upgrade
	return a
