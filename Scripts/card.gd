class_name Card
extends Control

signal clicked(card: CardData)

var card_data: CardData = null
@onready var description: Label = $Container/Description
@onready var name_label: Label = $Container/NameLabel
@onready var energy_cost: Label = $Container/Costs/EnergyCost
@onready var coin_cost: Label = $Container/Costs/CoinCost

var pending_data: CardData

func setup(data: CardData) -> void:
	card_data = data
	update_display()

func _ready():
	update_display()

func update_display():
	if card_data == null:
		return
	name_label.text = card_data.card_name
	energy_cost.text = str(card_data.energy_cost)
	coin_cost.text = str(card_data.coin_value)
	description.text = CardLibrary.generate_description(card_data)
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_global_rect().has_point(event.global_position):
			clicked.emit(card_data)
