class_name CardData
extends Resource
#TODO Change main datatypes of cards.


@export var card_name: String = ""
@export var description: String = ""
@export var rarity: GlobalEnums.CardRarity
@export var color: GlobalEnums.CardColor = GlobalEnums.CardColor.RED
@export var card_type: GlobalEnums.CardType = GlobalEnums.CardType.PERMANENT
@export var art: Texture2D
@export var uid: int = 0

@export var energy_cost: int = 1
@export var energy_cost_upgrade: int = 0
@export var coin_value: int = 0
@export var coin_value_upgrade: int = 0

@export var actions: Array[CombatAction] = []

@export var max_upgrades: int = 5
var upgrade_level: int = 0
var in_field: bool = false

@export var returned_on_death:bool = true
#TODO CARDACTION Introduce a proper CardAction system; or just action in general tbh
#Each card becomes a list of actions
#Actions determine their own target groups



func upgrade() -> void:
	if upgrade_level >= max_upgrades:
		return
	energy_cost = max(0, energy_cost - energy_cost_upgrade)
	coin_value = max(0, coin_value - coin_value_upgrade)
	for action in actions:
		action.upgrade()
	card_name += "+"
	upgrade_level += 1
	description = ActionLibrary.generate_description(actions)


func preview_upgrade() -> CardData:
	var copy = duplicate(true)
	copy.upgrade()
	return copy

func can_upgrade() -> bool:
	return upgrade_level < max_upgrades
