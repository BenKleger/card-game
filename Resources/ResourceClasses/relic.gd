class_name RelicData
extends Resource
@export var relic_name: String = ""
@export var description: String = ""
@export var rarity: GlobalEnums.CardRarity
@export var start_combat_effects: Array[Effect] = []
var on_collected: Callable =  func(): pass
