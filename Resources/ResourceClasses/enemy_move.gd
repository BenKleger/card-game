class_name EnemyMove
extends Resource

@export var intent_type: GlobalEnums.IntentType
@export var value: int #LEGACY
@export var damage: int = 0
@export var block: int = 0
@export var description: String
@export var target_effects: Array[Effect] = []
@export var self_effects: Array[Effect] = []
@export var icon: Texture2D
