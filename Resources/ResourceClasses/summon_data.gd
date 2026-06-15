class_name SummonData
extends Resource
@export var summon_name: String = ""
@export var summon_max_hp: int = 0
@export var summon_max_hp_up: int = 0
@export var takes_aggro: bool = false
@export var is_passive: bool = false
@export var returned_on_death: bool = true
@export var actions : Array[CombatAction] = []
