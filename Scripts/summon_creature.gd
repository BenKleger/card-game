class_name SummonCreature
extends Control

var card_data: CardData
var current_hp: int
var max_hp: int
var block: int = 0
var effects: Array[Effect] = []
var takes_aggro: bool = false
var is_passive: bool = false
var uid: int = 0
var used_this_turn: bool = false

@onready var hp_label: Label = $StatBox/LabelContainer/HPLabel
@onready var name_label: Label = $StatBox/LabelContainer/NameLabel
@onready var block_label: Label = $StatBox/LabelContainer/BlockLabel
@onready var effects_container: HBoxContainer = $StatBox/EffectsContainer
@onready var description_label: Label = $StatBox/DescriptionLabel
var permanent_block :int = 0
func _ready() -> void:
	permanent_block = 0
	

func get_effect(effect_type: GDScript) -> Effect:
	for effect in effects:
		if effect.get_script() == effect_type:
			return effect
	return null

func setup(data: CardData) -> void:
	card_data = data
	current_hp = data.summon_hp
	max_hp = data.summon_hp
	takes_aggro = data.takes_aggro
	is_passive = data.is_passive
	description_label.text = data.description
	uid = CardLibrary.get_next_uid()
	update_stats()

func update_stats() -> void:
	hp_label.text = str(current_hp)+"/"+str(max_hp)
	block_label.text = str(block)
	name_label.text = card_data.card_name if card_data else ""

signal clicked(summon: SummonCreature)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(self)
