class_name SummonCreature
extends Control

var source_card: CardData = null  
var effective:CardData = null
var current_hp: int
var max_hp:int 
var block: int = 0
var effects: Array[Effect] = []
var takes_aggro: bool = false
var is_passive: bool = false
var uid: int = 0
var summon_data: SummonData = null
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

func setup(data: SummonData) -> void:
	summon_data = data
	current_hp = data.summon_max_hp
	max_hp = data.summon_max_hp
	takes_aggro = data.summon_max_hp
	is_passive = data.summon_max_hp
	description_label.text = ActionLibrary.generate_description(data.actions)
	uid = CardLibrary.get_next_uid()
	update_stats()
	_update_effects_display()

func _update_effects_display() -> void:
	if effects_container == null:
		return
	for child in effects_container.get_children():
		child.queue_free()
	for effect in effects:
		var label = Label.new()
		label.text = _effect_abbrev(effect)
		label.add_theme_font_size_override("font_size", 11)
		label.add_theme_color_override("font_color", _effect_color(effect))
		effects_container.add_child(label)


func _effect_abbrev(effect: Effect) -> String:
	match effect.name:
		"Bleed": return "BLD " + str(effect.stacks)
		"Regen": return "REG " + str(effect.stacks)
		"Strength": return "STR " + str(effect.stacks)
		"Weak": return "WK " + str(effect.stacks)
		"Vulnerable": return "VUL " + str(effect.stacks)
		_: return effect.name.substr(0, 3).to_upper() + " " + str(effect.stacks)

func _effect_color(effect: Effect) -> Color:
	match effect.name:
		"Bleed": return Color(0.85, 0.2, 0.2)
		"Regen": return Color(0.2, 0.85, 0.4)
		"Strength": return Color(0.9, 0.5, 0.1)
		"Weak": return Color(0.8, 0.8, 0.2)
		"Vulnerable": return Color(0.6, 0.2, 0.9)
		_: return Color(0.8, 0.8, 0.8)


@onready var color_rect: ColorRect = $ColorRect
func update_stats() -> void:
	hp_label.text = str(current_hp)+"/"+str(max_hp)
	block_label.text = str(block)
	name_label.text = summon_data.summon_name if summon_data else ""
	_update_effects_display()
	match source_card.color:
		GlobalEnums.CardColor.RED:
			color_rect.color = Color("#7A4545")
		GlobalEnums.CardColor.BLUE:
			color_rect.color = Color("#455E7A")
		GlobalEnums.CardColor.PURPLE:
			color_rect.color = Color("#65457A")
		GlobalEnums.CardColor.GREEN:
			color_rect.color = Color("#4C704C")
		_:
			color_rect.color = Color("#606060")

signal clicked(summon: SummonCreature)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(self)
