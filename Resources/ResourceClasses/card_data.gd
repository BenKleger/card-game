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
@export var effects: Array[Effect] 
@export var draw: int = 0
@export var energy_cost: int = 1
@export var energy_gain: int = 0
@export var coin_value: int = 0
@export var coin_gain: int = 0

#upgrade values
@export var damage_upgrade:int = 0
@export var block_upgrade: int = 0
@export var effects_upgrade: Array[Effect] 
@export var draw_upgrade: int = 0
@export var energy_cost_upgrade: int = 0
@export var energy_gain_upgrade: int = 0
@export var coin_value_upgrade: int = 0
@export var coin_gain_upgrade: int = 0

#Summon values
@export var summon_hp: int = 0
@export var takes_aggro: bool = false
@export var is_passive: bool = false

func get_energy_cost()->int:
	return max(0, energy_cost - energy_cost_upgrade*upgrade_level)
	
func get_coin_cost()->int:
	return max(0, coin_value - coin_value_upgrade*upgrade_level)
	
func get_damage()->int:
	return damage+damage_upgrade*upgrade_level
	
func get_block()->int:
	return block+block_upgrade*upgrade_level
	
func get_effects()->Array[Effect] :
	var upgraded_effects:Array[Effect]=[]
	for i: int in range(upgrade_level):
		var effect: Effect = effects[i].instantiate()
		effect.stacks = effects[i].stacks + effects_upgrade[i].stacks
		upgraded_effects.append(effect) 
	return upgraded_effects

func get_energy_gain():
	return energy_gain+energy_gain_upgrade*upgrade_level

func get_display_name() -> String:
	if upgrade_level == 0:
		return card_name
	else:
		var card: String = card_name
		for i in range(upgrade_level):
			card+="+"
		return card

func get_description() -> String: #TODO OOO
	if upgrade_level == 0:
		return description
	var desc: String = ""
	if get_damage() > 0:
		desc.insert(desc.length(),(str(get_damage)+" Damage\n"))
	if get_block() > 0:
		desc.insert(desc.length(),(str(get_block())+" Block\n"))
	if get_energy_gain() > 0:
		desc.insert(desc.length(),(str(get_energy_gain())+" Energy\n"))
		
	
	return ""

func update_display():
	pass

enum TargetType { NONE, SINGLE_ENEMY, ALL_ENEMIES, SELF }
@export var target_type: TargetType

@export var max_upgrades: int = 1
var upgrade_level: int = 0

func upgrade() -> void:
	if not can_upgrade():
		return
	upgrade_level += 1
	
func can_upgrade() -> bool:
	return upgrade_level < max_upgrades
