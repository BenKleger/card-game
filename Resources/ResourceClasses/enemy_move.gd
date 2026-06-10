class_name EnemyMove
extends Resource

@export var intent_type: GlobalEnums.IntentType
@export var value: int
@export var description: String
@export var effects_on_target: Array[Effect] = []
@export var effects_on_self: Array[Effect] = []
@export var icon: Texture2D
