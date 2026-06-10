class_name EnemyData
extends Resource

@export var uid: int = 0
@export var actions_per_turn: int = 1
@export var enemy_name: String = ""
@export var base_hp: int = 1
@export var starting_moves: Array[EnemyMove] = []
@export var move_pool_loop: Array[EnemyMove] = []
@export var art: Texture2D
@export var gold_drop: int = 0  # add this
