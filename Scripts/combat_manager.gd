class_name CombatManager
extends Node

# Phase of combat
enum Phase{PLAYER_TURN_START,PLAYER_TURN,PLAYER_TURN_END,END_COMBAT}

#TODO Perhaps changing player to players; allowing for summoning friendly creatures

var hand_size_modifier: int = 0 #TODO Unused
var card_draw_modifier: int = 0
var enemies: Array[EnemyCreature]
var combat_seed: int
const ENEMY_SCENE = preload("res://scenes/EnemyCreature.tscn")
const CARD_SCENE = preload("res://scenes/Card.tscn")
@onready var deck_manager: DeckManager = $DeckManager
@onready var player: PlayerCreature = $UI/UIHeirarchy/BattleAreaNode/BattleArea/PlayerArea/PlayerCreature
var turn_number: int = 1
var selected_card: CardData = null
var phase: Phase = Phase.PLAYER_TURN_START

@onready var summon_container: GridContainer = $UI/UIHeirarchy/BattleAreaNode/BattleArea/PlayerArea/SummonContainer
const SUMMON_SCENE = preload("res://Scenes/SummonCreature.tscn")
var summons: Array[SummonCreature] = []

func _ready() -> void:
	
	turn_number = 1
	# setup player
	player.current_hp = RunState.current_hp
	player.max_hp = RunState.max_hp
	player.energy = RunState.max_energy
	_update_player_ui()
	
	# setup deck
	deck_manager.initialize(RunState.deck)
	_update_deck_ui()

	# setup enemies (load from encounter data)
	_spawn_enemies()
	
	_connect_signals()
	
	
	
	_start_of_combat_player()
	_start_of_combat_enemy()
	
	
	# start
	phase = Phase.PLAYER_TURN_START
	advance_phase()

func _start_of_combat_player() -> void:
	_proc_effects(player, GlobalEnums.ProcOn.START_COMBAT)
	# Apply relic effects at combat start
	for relic in RunState.relics:
		for effect in relic.start_combat_effects:
			apply_effect(effect.duplicate(), player)

func _start_of_combat_enemy() -> void:
	for enemy in enemies:
		_proc_effects(enemy, GlobalEnums.ProcOn.START_COMBAT)
		_display_enemy_intent(turn_number - 1, enemy)

func apply_effect(effect: Effect, target: Node) -> void:
	# Check if effect of same type already exists — add stacks
	for existing in target.effects:
		if existing.get_script() == effect.get_script():
			existing.stacks += effect.stacks
			return
	# Otherwise add fresh
	var new_effect = effect.duplicate()
	target.effects.append(new_effect)
	new_effect.on_applied(target)
	check_death(target)

@onready var enemy_area = $UI/UIHeirarchy/BattleAreaNode/BattleArea/EnemyArea
func _spawn_enemies() -> void:
	var node = RunState.map_data.get_current_node()
	if node == null or node.encounter == null:
		push_error("No encounter data on current node")
		return
	for enemy_data in node.encounter.enemies:
		var enemy = ENEMY_SCENE.instantiate()
		enemy.custom_minimum_size = Vector2(150, 200)
		enemy.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		enemy.data = enemy_data
		enemy.current_hp = enemy_data.base_hp
		enemy.max_hp = enemy_data.base_hp
		enemy_area.add_child(enemy)

		enemies.append(enemy)

func _on_deck_button_pressed() -> void:
	RunState.open_deck_viewer(self, RunState.deck, "Deck")
func _on_discard_button_pressed() -> void:
	#Visualize discard pile
	RunState.open_deck_viewer(self, deck_manager.discard_pile, "Discard Pile")

func _on_draw_button_pressed() -> void:
	#Visualize draw pile
	RunState.open_deck_viewer(self, deck_manager.draw_pile, "Draw Pile")

func _on_card_clicked(card: CardData) -> void:
	# reset all cards to original position first
	_reset_card_positions()
	select_card(card)

@onready var end_turn_button: Button = $UI/UIHeirarchy/BottomBarNode/BottomBar/EndTurnButton

func _connect_signals() -> void:
	# TODO: $DeckButton.pressed.connect(_on_deck_button_pressed) — show deck viewer
	# TODO: $DiscardButton.pressed.connect(_on_discard_button_pressed) — show discard viewer
	if not end_turn_button.pressed.is_connected(end_turn):
		end_turn_button.pressed.connect(end_turn)
	for enemy in enemies:
		enemy.clicked.connect(_on_enemy_clicked)

func _on_enemy_clicked(enemy: EnemyCreature) -> void:
	select_target(enemy)

func select_card(card: CardData) -> void:
	if selected_card == card:
		select_target()
		return
	selected_card = card
	_raise_selected_card(card)
	# TODO highlight card visually


@onready var hand_container: HBoxContainer = $UI/UIHeirarchy/BottomBarNode/BottomBar/HandContainer
func _reset_card_positions() -> void:
	for child in hand_container.get_children():
		child.position.y = 0
		

func _raise_selected_card(card: CardData) -> void:
	_reset_card_positions()
	for child in hand_container.get_children():
		if child.card_data.uid == card.uid:
			child.position.y = -30

func select_target(target: Node = null) -> void:
	if phase != Phase.PLAYER_TURN:
		# TODO shake cards as not your turn
		return
	if selected_card == null:
		return
	if selected_card.card_type == GlobalEnums.CardType.FIELD:
		summon_logic(target)
		return
	card_logic(target)

func card_logic(target: Node) -> void:
	if player.energy < selected_card.energy_cost:
		# TODO shake animation, highlight energy in red
		return
	match selected_card.target_type:
		CardData.TargetType.NONE:
			_execute_card(selected_card, null)
		CardData.TargetType.SELF:
			_execute_card(selected_card, player)
		CardData.TargetType.SINGLE_ENEMY:
			if target == null or not target is EnemyCreature:
				return
			_execute_card(selected_card, target)
		CardData.TargetType.ALL_ENEMIES:
			_execute_card(selected_card, null)
	selected_card = null
	_reset_card_positions()

func summon_logic(target: Node) -> void:
	# Spawning a new summon
	if player.energy < selected_card.energy_cost:
		return
	spawn_summon(selected_card)
	selected_card = null
	_reset_card_positions()

func spawn_summon(card_data: CardData) -> void:
	if card_data.card_type != GlobalEnums.CardType.FIELD:
		return
	var summon = SUMMON_SCENE.instantiate()
	summon.uid = CardLibrary.get_next_uid()
	summon_container.add_child(summon)
	summon.setup(card_data)
	summons.append(summon)
	deck_manager.summons.append(card_data)
	card_data.in_field = true
	player.energy -= card_data.energy_cost
	deck_manager.discard(card_data)
	summon.clicked.connect(_on_summon_clicked)
	_remove_card_from_hand(card_data)

func _on_summon_clicked(summon: SummonCreature) -> void:
	if phase != Phase.PLAYER_TURN:
		return
	if summon.used_this_turn:
		# TODO visual feedback — shake or flash
		return
	_execute_summon_action(summon)

func _execute_summon_action(summon: SummonCreature) -> void:
	var card = summon.card_data
	var targets: Array = []
	match card.target_type:
		CardData.TargetType.SINGLE_ENEMY:
			if enemies.is_empty():
				return
			targets = [enemies[0]]  # hits first enemy for now, targeting later
		CardData.TargetType.ALL_ENEMIES:
			targets = enemies.duplicate()
		CardData.TargetType.SELF:
			targets = [player]
		CardData.TargetType.NONE:
			pass
	
	for t in targets:
		if card.damage > 0:
			_attack_target(card.damage, t, summon)
		for effect in card.effects:
			apply_effect(effect.duplicate(), t)
		t.update_stats()
	
	if card.block > 0:
		player.block += card.block
	if card.draw > 0:
		_draw_cards(card.draw)
	if card.energy_gain > 0:
		player.energy += card.energy_gain
	
	summon.used_this_turn = true
	summon.modulate = Color(0.5, 0.5, 0.5, 1.0)  # grey out when used
	_update_player_ui()
	_update_deck_ui()

func _execute_card(card: CardData, target) -> void:
	_apply_card_effects(card, target)
	match card.card_type:
		GlobalEnums.CardType.TEMPORARY:
			player.energy -= card.energy_cost
			_remove_card_from_hand(card)
			deck_manager.exhaust(card)
		_:
			player.energy -= card.energy_cost
			_remove_card_from_hand(card)
			deck_manager.discard(card)

func _remove_card_from_hand(card: CardData) -> void:
	for child in hand_container.get_children():
		if child.card_data.uid == card.uid:
			child.queue_free()
			break
	for i in deck_manager.hand.size():
		if deck_manager.hand[i].uid == card.uid:
			deck_manager.hand.remove_at(i)
			break
	_update_deck_ui()
	_update_player_ui()

@onready var draw_button: Button = $UI/UIHeirarchy/BottomBarNode/BottomBar/DrawButton
@onready var discard_button: Button = $UI/UIHeirarchy/BottomBarNode/BottomBar/DiscardButton
@onready var exhaust_button: Button 

func _update_deck_ui() -> void:
	draw_button.text = "Deck\n" + str(deck_manager.get_draw_count())
	discard_button.text = "Discard\n" + str(deck_manager.get_discard_count())

func _apply_card_effects(card: CardData, target: Node) -> void:
	var targets: Array = []
	if card.target_type == CardData.TargetType.ALL_ENEMIES:
		targets = enemies
	elif target != null:
		targets = [target]
	for t in targets:
		if card.damage != 0:
			_attack_target(card.damage, t, player)
		for effect in card.effects:
			if effect.name == "BleedSelf":
				apply_effect(effect, player)
			else:
				apply_effect(effect, t)
	if card.block != 0:
		player.block += card.block
	if card.draw != 0:
		_draw_cards(card.draw)
	if card.energy_gain != 0:
		player.energy += card.energy_gain
	for t in targets:
		if t is EnemyCreature:
			t.update_stats()

func _unhandled_input(event: InputEvent) -> void:
	if phase == Phase.PLAYER_TURN:
		if event.is_action_pressed("End_Turn"):
			popup_to_confirm_end_turn()
		else:
			if Input.is_action_pressed("f"):
				for i in 10:
					if event.is_action_pressed(str(i)):
						select_card_by_index(i,true)
						break
				return
			for i in 10:
				if event.is_action_pressed(str(i)):
					select_card_by_index(i)
					break
			

func popup_to_confirm_end_turn() -> void:
	# TODO confirm dialog, maybe a flag to suppress input handling during it
	end_turn()

func select_card_by_index(idx: int, field = false) -> void:
	if !field:
		if idx >= deck_manager.hand.size():
			return
		select_card(deck_manager.hand[idx])
		return
	#in-field card
	if idx >= deck_manager.summons.size():
		print("1")
		return
	select_card(deck_manager.summons[idx])

func _draw_cards(n: int) -> void:
	var effective_max = RunState.max_hand_size + hand_size_modifier
	var space = effective_max - deck_manager.hand.size()
	var drawn = deck_manager.draw(min(n, space))
	deck_manager.hand.append_array(drawn)
	for card_data in drawn:
		var card = CARD_SCENE.instantiate()
		card.setup(card_data)
		card.clicked.connect(_on_card_clicked)
		hand_container.add_child(card)
	_update_deck_ui()

@onready var energy_label: Label = $UI/UIHeirarchy/BottomBarNode/BottomBar/EnergyLabel
func _update_player_ui() -> void:
	player.update_stats()
	energy_label.text = str(player.energy) + "/" +str(player.max_energy)

func _attack_target(damage:int, target:Node, source: Node)->void:
	#Str
	for effect in source.effects:
		if effect is EffectStrength:
			damage += effect.stacks
			break
			
		# Weak — source deals less damage
	for effect in source.effects:
		if effect is EffectWeak:
			damage = int(damage * 0.75)
			break
	
	# Vulnerable — target takes more damage
	for effect in target.effects:
		if effect is EffectVulnerable:
			damage = int(damage * 1.5)
			break
			
	if target.block == 0:
		_proc_effects(target, GlobalEnums.ProcOn.ON_HP_DAMAGED, source)
		target.current_hp -= damage
		check_death(target)
	elif target.block < damage:
		_proc_effects(target, GlobalEnums.ProcOn.ON_SHIELD_DAMAGED, source)
		_proc_effects(target, GlobalEnums.ProcOn.ON_HP_DAMAGED, source)
		#TODO Add animation
		var block_damage:int = target.block
		target.block = 0
		#TODO Add animation
		target.current_hp -= (damage-block_damage)
		check_death(target)
	else: #Target fully blocks
		#TODO Add animation
		target.block -= damage
	_proc_effects(target, GlobalEnums.ProcOn.ON_ATTACK,source)
		
		
	#Modify UI
	if target == player:
		_update_player_ui()
	else:
		target.update_stats()

func end_turn() -> void:
	if phase != Phase.PLAYER_TURN:
		return
	phase = Phase.PLAYER_TURN_END
	advance_phase()
	turn_number += 1
	
	_proc_effects(player, GlobalEnums.ProcOn.TURN_END)

func advance_phase() -> void:
	match phase:
		Phase.PLAYER_TURN_START:
			
			_do_player_turn_start()
			phase = Phase.PLAYER_TURN

		Phase.PLAYER_TURN_END:
			_do_player_turn_end()
			_do_enemy_turn_start()
			_do_enemy_turn()
			_do_enemy_turn_end()
			phase = Phase.PLAYER_TURN_START
			advance_phase.call_deferred()

		Phase.END_COMBAT:
			if enemies.is_empty():
				_end_combat_victory()
			else:
				_end_combat_loss()

func _do_player_turn_start():
	player.block = 0
	for summon in summons:
		summon.used_this_turn = false
		summon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	_proc_effects(player, GlobalEnums.ProcOn.TURN_START)
	_draw_cards(card_draw_modifier+RunState.card_draw)
	player.energy = player.max_energy
	_update_player_ui()
	check_death(player)

func _end_combat_loss():
	#TODO Run loss animation
	#TODO bring up title screen / game over with some stats eventually
	RunState.scene_history.clear()
	get_tree().change_scene_to_file.call_deferred("res://Scenes/lose.tscn")

func _end_combat_victory() -> void:
	RunState.current_hp = player.current_hp
	RunState.map_data.get_current_node().cleared = true
	RunState.push_scene.call_deferred("res://Scenes/RewardManager.tscn")

func check_death(creature: Node):
	if creature.current_hp <= 0:
		kill_creature(creature)
		creature.update_stats()

func kill_creature(creature: Node) -> void:
	if creature == player:
		phase = Phase.END_COMBAT
		advance_phase()
	else:
		#TODO enemy death animation
		enemies.erase(creature)
		creature.queue_free()
		if enemies.is_empty():
			phase = Phase.END_COMBAT
			advance_phase()

func _do_enemy_turn_start() -> void:
	for enemy in enemies:
		enemy.block = 0
		_proc_effects(enemy, GlobalEnums.ProcOn.TURN_START)
		check_death(enemy)

func _do_enemy_turn() -> void:
	for enemy in enemies:
		for a in enemy.data.actions_per_turn:
			_pick_enemy_move(turn_number, enemy)
		_display_enemy_intent(turn_number, enemy)
		check_death(enemy)

func _pick_enemy_move(turn:int, enemy: EnemyCreature):
	var current_move:EnemyMove
	if turn-1 < enemy.data.starting_moves.size():
		current_move = enemy.data.starting_moves[turn-1]
	else:
		current_move = enemy.data.move_pool_loop[(turn-enemy.data.starting_moves.size()-1) % enemy.data.move_pool_loop.size()]
	
	_do_current_move(current_move,enemy)
	
func _display_enemy_intent(turn:int, enemy: EnemyCreature):
	var next_move :EnemyMove
	if turn < enemy.data.starting_moves.size():
		next_move = enemy.data.starting_moves[turn]
	else:
		next_move = enemy.data.move_pool_loop[(turn-enemy.data.starting_moves.size()) % enemy.data.move_pool_loop.size()]
	
	_display_next_intent(next_move,enemy)

func _do_current_move(move: EnemyMove, enemy: EnemyCreature):
	match move.intent_type:
		#TODO Add animations
		GlobalEnums.IntentType.ATTACK:
			_attack_target(move.value, player, enemy)
		GlobalEnums.IntentType.BLOCK:
			enemy.block += move.value
	for effect in move.effects_on_target:
		print("Applying target effect: ", effect)
		effect.proc(player, enemy)
	for effect in move.effects_on_self:
		print("Applying self effect: ", effect)
		effect.proc(enemy, enemy)

func _display_next_intent(move: EnemyMove, enemy: EnemyCreature):
	enemy.display_move(move)
	#TODO Add animation

func _do_player_turn_end():
	_proc_effects(player, GlobalEnums.ProcOn.TURN_END)
	for card in deck_manager.hand.duplicate():
		deck_manager.discard(card)
	deck_manager.hand.clear()
	for child in hand_container.get_children():
		child.queue_free()
	_update_deck_ui()

func _do_enemy_turn_end():
	for enemy in enemies:
		_proc_effects(enemy, GlobalEnums.ProcOn.TURN_END)

func _proc_effects(creature: Node, proc_on: GlobalEnums.ProcOn, from: Node = null) -> void:
	for effect in creature.effects:
		if effect.proc_on == proc_on:
			effect.proc(creature, from)
			creature.update_stats()

#const MAP_VIEWER = preload("res://Scenes/MapManager.tscn")
#var map_open: bool = false
#
#func _on_map_button_pressed() -> void:
	#if map_open:
		#return
	#map_open = true
	#var map = MAP_VIEWER.instantiate()
	#map.preview_mode = true
	#add_child(map)
	#map.close_requested.connect(func():
		#map.queue_free()
		#map_open = false
	#)


func _on_exhaut_button_pressed() -> void:
	pass # Replace with function body.
