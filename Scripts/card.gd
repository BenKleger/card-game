class_name Card
extends Control

signal clicked(card: Card)

var card_data: CardData = null
@onready var description: Label = $Container/Description
@onready var name_label: Label = $Container/NameLabel
@onready var energy_cost: Label = $Container/Costs/EnergyCost
@onready var coin_cost: Label = $Container/Costs/CoinCost
@onready var color_rect: ColorRect = $ColorRect
var chain_bonus: int = 0

func update_chain_bonus(bonus:int) -> void:
	chain_bonus = bonus
	update_display()

var pending_data: CardData

func setup(data: CardData) -> void:
	card_data = data
	_ready()

func _ready():
	update_display()

var effective :CardData= get_effective_card_data()
func get_effective_card_data() -> CardData:
	if !card_data: 
		return
	var temp := card_data.duplicate(true)
	for up in range(chain_bonus):
		temp.upgrade()
	return temp

func update_display():
	if card_data == null:
		return
	effective = get_effective_card_data()
	name_label.text = effective.card_name
	energy_cost.text = str(effective.energy_cost)
	coin_cost.text = str(effective.coin_value)
	description.text = ActionLibrary.generate_description(effective.actions)
	match card_data.color:
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


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_global_rect().has_point(event.global_position):
			clicked.emit(self)
