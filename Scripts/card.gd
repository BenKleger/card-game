class_name Card
extends Control

signal clicked(card: CardData)

var card_data: CardData

func setup(data: CardData) -> void:
	card_data = data.duplicate() 
	card_data.uid = data.uid  
	$Container/Name.text = data.card_name
	$Container/Costs/EnergyCost.text = str(data.energy_cost)
	$Container/Costs/CoinCost.text = str(data.coin_value)
	$Container/Description.text = data.description


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_global_rect().has_point(event.global_position):
			clicked.emit(card_data)
