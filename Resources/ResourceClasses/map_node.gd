class_name MapNode
extends Resource
@export var type: GlobalEnums.MapNodeType
@export var connections: Array[int]  # indices of connected nodes
@export var cleared: bool = false
@export var node_index: int
@export var encounter: EncounterData
@export var current_floor: int = 0
