class_name UpgradePreview
extends CanvasLayer

signal confirmed(card: CardData)

const CARD_SCENE = preload("res://Scenes/Card.tscn")

@onready var upgraded_card_node: Control = null
@onready var current_card_node: Control = null

var original_card: CardData
var preview_card: CardData

@onready var current_card_holder: Control = $PanelContainer/VBoxContainer/HBoxContainer/CurrentCardHolder
@onready var upgraded_card_holder: Control = $PanelContainer/VBoxContainer/HBoxContainer/UpgradedCardHolder
@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleLabel

func open(card: CardData) -> void:
	if RunState.ui_locked:
		return
	RunState.ui_locked = true
	print(card.uid)
	# clear old
	for c in current_card_holder.get_children():
		c.queue_free()
	for c in upgraded_card_holder.get_children():
		c.queue_free()
	# instantiate fresh cards
	current_card_node = CARD_SCENE.instantiate()
	upgraded_card_node = CARD_SCENE.instantiate()
	current_card_holder.add_child(current_card_node)
	upgraded_card_holder.add_child(upgraded_card_node)
	# setup data
	current_card_node.setup(card)
	title_label.text = "Upgrade Menu\n" + str(RunState.upgrades_available) + " Upgrades Available"
	var upgraded = card.preview_upgrade()
	upgraded_card_node.setup(upgraded)
	

func _on_confirm_button_pressed() -> void:
	emit_signal("confirmed", original_card)
	RunState.ui_locked = false
	
	queue_free()


func _on_cancel_button_pressed() -> void:
	RunState.ui_locked = false
	queue_free()
