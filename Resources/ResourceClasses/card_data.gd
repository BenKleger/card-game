class_name CardData
extends Resource
#TODO Change main datatypes of cards.


@export var card_name: String = ""
@export var description: String = ""
@export var rarity: GlobalEnums.CardRarity
@export var color: GlobalEnums.CardColor = GlobalEnums.CardColor.RED
@export var card_type: GlobalEnums.CardType = GlobalEnums.CardType.PERMANENT
@export var in_field:bool = false
@export var art: Texture2D
@export var uid: int = 0

#Base Values
@export var damage: int = 0
@export var block:int = 0
@export var effects: Array[Effect] =[]
@export var self_effects: Array[Effect] =[]
@export var draw: int = 0
@export var energy_cost: int = 1
@export var energy_gain: int = 0
@export var coin_value: int = 0
@export var coin_gain: int = 0
#TODO CARDACTION Introduce a proper CardAction system; or just action in general tbh
#Each card becomes a list of actions
#Actions determine their own target groups
enum TargetType { NONE, SINGLE_ENEMY, ALL_ENEMIES, SELF, SINGLE_ALLY, ALL_ALLIES }
@export var target_type: TargetType

#upgrade values
@export var damage_upgrade:int = 0
@export var block_upgrade: int = 0
@export var effects_upgrade: Array[Effect] = []
@export var self_effects_upgrade: Array[Effect] =[]
@export var draw_upgrade: int = 0
@export var energy_cost_upgrade: int = 0
@export var energy_gain_upgrade: int = 0
@export var coin_value_upgrade: int = 0
@export var coin_gain_upgrade: int = 0

#Summon values
@export var summon_hp: int = 0
@export var takes_aggro: bool = false
@export var is_passive: bool = false
@export var can_target_summons : bool = true
@export var returned_on_death: bool = true

func upgrade() -> void:
	if not can_upgrade():
		return
	damage += damage_upgrade
	block += block_upgrade
	energy_cost = max(0, energy_cost - energy_cost_upgrade)
	energy_gain += energy_gain_upgrade
	coin_value = max(0, coin_value - coin_value_upgrade)
	coin_gain += coin_gain_upgrade
	draw += draw_upgrade
	# Effects handled separately
	_apply_effect_upgrades()
	upgrade_level += 1
	description = _generate_upgraded_description()

func _apply_effect_upgrades() -> void:
	for up in effects_upgrade:
		for e in effects:
			if e.name == up.name:
				e.stacks += up.stacks

func _generate_upgraded_description() -> String: #TODO OOO
	if upgrade_level == 0:
		return description
	var desc: String = ""
	if damage > 0:
		desc.insert(desc.length(),(str(damage)+" Damage\n"))
	if block > 0:
		desc.insert(desc.length(),(str(block)+" Block\n"))
	if energy_gain > 0:
		desc.insert(desc.length(),(str(energy_gain)+" Energy\n"))
	for effect in effects:
		desc.insert(desc.length(),(str(effect.name)+" "+str(effect.stacks)))
	
	
	return desc

func update_display():
	pass

@export var max_upgrades: int = 1
var upgrade_level: int = 0

	
func can_upgrade() -> bool:
	return upgrade_level < max_upgrades
