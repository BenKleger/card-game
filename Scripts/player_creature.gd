class_name PlayerCreature
extends Control

var current_hp:int
var max_hp:int
var block: int
var energy: int
var max_energy: int = RunState.max_energy
var effects: Array[Effect]

signal clicked(player: PlayerCreature)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		clicked.emit(self)

@onready var effects_container: HBoxContainer = $StatBox/EffectsContainer

	

func update_stats() -> void:
	$StatBox/LabelContainer/HPLabel.text = str(current_hp)
	$StatBox/LabelContainer/BlockLabel.text = str(block)
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
