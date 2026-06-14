# EnemyMove.gd — simplified
class_name EnemyMove
extends Resource
@export var description: String
@export var icon: Texture2D
@export var display_intent: GlobalEnums.IntentType  # drives the intent icon/label
@export var actions: Array[CombatAction] = []
