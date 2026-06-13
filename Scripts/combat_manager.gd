class_name CombatManager
extends Node

# Phase of combat
enum Phase{PLAYER_TURN_START,PLAYER_TURN,PLAYER_TURN_END}

#TODO Perhaps changing player to players; allowing for summoning friendly creatures

var hand_size_modifier: int = 0 #TODO Unused
var card_draw_modifier: int = 0
var summon_slot_modifier: int = 0

enum SummonColumn { PASSIVE, NEUTRAL, TANK }
const BASE_SUMMON_SLOTS_PER_COLUMN: int = 1
var enemies: Array[EnemyCreature]
var combat_seed: int
const ENEMY_SCENE = preload("res://scenes/EnemyCreature.tscn")
const CARD_SCENE = preload("res://Scenes/Card.tscn")
@onready var deck_manager: DeckManager = $DeckManager
@onready var player: PlayerCreature = $UI/UIHeirarchy/BattleAreaNode/BattleArea/PlayerArea/PlayerCreature
var turn_number: int = 1
var selected_card: CardData = null
var phase: Phase = Phase.PLAYER_TURN_START

@onready var passive_column: VBoxContainer = $UI/UIHeirarchy/BattleAreaNode/BattleArea/PlayerArea/PassiveColumn
@onready var neutral_column: VBoxContainer = $UI/UIHeirarchy/BattleAreaNode/BattleArea/PlayerArea/NeutralColumn
@onready var tank_column: VBoxContainer = $UI/UIHeirarchy/BattleAreaNode/BattleArea/PlayerArea/TankColumn
const SUMMON_SCENE = preload("res://Scenes/SummonCreature.tscn")
var summons: Array[SummonCreature] = []

var selected_summon: SummonCreature = null

func _ready() -> void:
	
	turn_number = 1
	# setup player
	player.current_hp = RunState.current_hp
	player.max_hp = RunState.max_hp
	player.energy = RunState.max_energy
	update_player_ui()
	
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
	CombatEffects.proc_effects(player, GlobalEnums.ProcOn.START_COMBAT)
	# Apply relic effects at combat start
	for relic in RunState.relics:
		for effect in relic.start_combat_effects:
			CombatEffects.apply_effect(effect.duplicate(), player)

func _start_of_combat_enemy() -> void:
	for enemy in enemies:
		CombatEffects.proc_effects(enemy, GlobalEnums.ProcOn.START_COMBAT)
		_display_enemy_intent(turn_number - 1, enemy)

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
	player.clicked.connect(_on_player_clicked)

func _on_player_clicked(_player):
	if selected_card != null:
		select_target(player)
	elif selected_summon != null:
		_execute_summon_action(selected_summon, player)
		selected_summon = null
		return

	
	
func _on_enemy_clicked(enemy: EnemyCreature) -> void:
	if selected_summon != null:
		_execute_summon_action(selected_summon, enemy)
		selected_summon = null
		return

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
		if child.card_data == null:
			continue
			print("continued3")
		if child.card_data.uid == card.uid:
			child.position.y = -30
func select_target(target: Node = null) -> void:
	#TODO UNIFY CARD TARGETING
	if phase != Phase.PLAYER_TURN:
		# TODO shake cards as not your turn
		return
	if selected_card == null:
		return
	if selected_card.card_type == GlobalEnums.CardType.FIELD:
		summon_logic()
		selected_card = null
		_reset_card_positions()
		return
	card_logic(target)
	selected_card = null
	selected_summon = null
	if target != null:
		check_death(target)
	_reset_card_positions()

func card_logic(target: Node) -> void:
	if player.energy < selected_card.energy_cost:
		# TODO shake animation, highlight energy in red
		return
	match selected_card.target_type:
		CardData.TargetType.NONE:
			_execute_card(selected_card, null)
		CardData.TargetType.SELF:
			if target is SummonCreature:
				if not selected_card.can_target_summons:
					return

				_execute_card(selected_card, target)
			else:
				_execute_card(selected_card, player)
		
		CardData.TargetType.SINGLE_ENEMY:
			if target == null or not target is EnemyCreature:
				return
			_execute_card(selected_card, target)
		CardData.TargetType.ALL_ENEMIES:
			_execute_card(selected_card, null)
	check_death(target)
	selected_card = null
	_reset_card_positions()

func summon_logic() -> void:
	if player.energy < selected_card.energy_cost:
		return
	if not _can_spawn_summon(selected_card):
		# TODO visual feedback — column full or already in field
		selected_card = null
		_reset_card_positions()
		return
	spawn_summon(selected_card)
	selected_card = null
	_reset_card_positions()

func _get_summon_column_from_data(data: CardData) -> SummonColumn:
	if data.takes_aggro:
		return SummonColumn.TANK
	if data.is_passive:
		return SummonColumn.PASSIVE
	return SummonColumn.NEUTRAL

func _get_column_container(column: SummonColumn) -> VBoxContainer:
	match column:
		SummonColumn.PASSIVE:
			return passive_column
		SummonColumn.NEUTRAL:
			return neutral_column
		SummonColumn.TANK:
			return tank_column
	return passive_column

func _max_slots_for_column(_column: SummonColumn) -> int:
	return BASE_SUMMON_SLOTS_PER_COLUMN + summon_slot_modifier

func _get_alive_summons_in_column(column: SummonColumn) -> Array[SummonCreature]:
	var result: Array[SummonCreature] = []
	for child in _get_column_container(column).get_children():
		if child is SummonCreature and child.current_hp > 0:
			result.append(child)
	return result

func _get_first_alive_in_column(column: SummonColumn) -> SummonCreature:
	var alive := _get_alive_summons_in_column(column)
	if alive.is_empty():
		return null
	return alive[0]

func _can_spawn_summon(card_data: CardData) -> bool:
	if card_data.in_field:
		return false
	var column := _get_summon_column_from_data(card_data)
	return _get_alive_summons_in_column(column).size() < _max_slots_for_column(column)

func spawn_summon(card_data: CardData) -> void:
	if card_data.card_type != GlobalEnums.CardType.FIELD:
		return
	if not _can_spawn_summon(card_data):
		return
	var column := _get_summon_column_from_data(card_data)
	var summon = SUMMON_SCENE.instantiate()
	summon.uid = CardLibrary.get_next_uid()
	_get_column_container(column).add_child(summon)
	summon.setup(card_data)
	deck_manager.summons.append(card_data)
	card_data.in_field = true
	player.energy -= card_data.energy_cost
	deck_manager.exhaust(card_data)
	summon.clicked.connect(_on_summon_clicked)
	summons.append(summon)
	_remove_card_from_hand(card_data)
	update_player_ui()

func _on_summon_clicked(summon: SummonCreature) -> void:
	if selected_card != null:
		select_target(summon)
		return
	elif selected_summon != null:
		_execute_summon_action(selected_summon, summon)
		return
	selected_summon = summon 

func _is_valid_card_target(target: Node) -> bool:
	return (
		target is PlayerCreature
		or target is EnemyCreature
		or target is SummonCreature
	)

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
	deck_manager.hand = deck_manager.hand.filter(func(c):
		return c != null and c.uid != card.uid
)
	for child in hand_container.get_children():
		if child.card_data != null and child.card_data.uid == card.uid:
			child.queue_free()
	_update_deck_ui()
	update_player_ui()

@onready var draw_button: Button = $UI/UIHeirarchy/BottomBarNode/BottomBar/DrawButton
@onready var discard_button: Button = $UI/UIHeirarchy/BottomBarNode/BottomBar/DiscardButton
@onready var exhaust_button: Button = $UI/UIHeirarchy/BottomBarNode/BottomBar/ExhaustButton

func _update_deck_ui() -> void:
	draw_button.text = "Deck\n" + str(deck_manager.get_draw_count())
	discard_button.text = "Discard\n" + str(deck_manager.get_discard_count())
	exhaust_button.text = "Exhaust\n" + str(deck_manager.get_exhaust_count())


func _execute_summon_action(summon: SummonCreature, target: Node = null) -> void:
	
	if summon.used_this_turn or summon == null:
		return
	var card : CardData= summon.card_data
	var targets: Array[Node] = targets_by_card_type(summon,target)
	if targets == []:
		selected_summon = null
		return
	CombatEffects.resolve_action(
		summon,
		targets,
		card.damage,
		card.block,
		card.target_effects,
		card.self_effects)
	
	
	_draw_cards(summon.card_data.draw)
	player.energy += summon.card_data.energy_gain
	RunState.gold += summon.card_data.coin_gain
	summon.used_this_turn = true
	summon.modulate = Color(0.5, 0.5, 0.5, 1.0)  # grey out when used
	update_player_ui()
	_update_deck_ui()
	check_death(target)
	selected_summon = null

func targets_by_card_type( summon:SummonCreature, target:Node) -> Array[Node]:
	var card : CardData= summon.card_data
	var targets: Array[Node] = []
	match card.target_type:
		CardData.TargetType.SINGLE_ENEMY:
			for enemy in enemies:
				if target == enemy:
					return [enemy]
			return []
		CardData.TargetType.ALL_ENEMIES:
			targets.append_array(enemies)
		CardData.TargetType.SELF:
			return [summon]
		CardData.TargetType.SINGLE_ALLY:
			if target == player:
				return [player]
			else:
				for sum in summons:
					if target == sum:
						return [sum]
		CardData.TargetType.ALL_ALLIES:
			targets.append_array(summons)
			targets.append(player)
		CardData.TargetType.NONE:
			targets = [target]
	return targets

func _apply_card_effects(card: CardData, target: Node) -> void:
	var targets: Array = []
	if card.target_type == CardData.TargetType.ALL_ENEMIES:
		targets = enemies
	elif target != null:
		targets = [target]
	CombatEffects.resolve_action(
	player,
	targets,
	card.damage,
	card.block,
	card.target_effects,
	card.self_effects
	)
	player.energy += card.energy_gain
	

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
		if event.is_action_pressed("Deselect"):
			selected_card = null
			selected_summon = null
			_reset_card_positions()

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
		return
	select_card(deck_manager.summons[idx])

func _draw_cards(n: int) -> void:
	var effective_max = RunState.max_hand_size + hand_size_modifier
	var space = effective_max - deck_manager.hand.size()
	var drawn = deck_manager.draw(min(n, space))
	deck_manager.hand.append_array(drawn)
	for card_data in drawn:
		var card = CARD_SCENE.instantiate()
		card.clicked.connect(_on_card_clicked)
		hand_container.add_child(card)
		
		card.setup(card_data)
	_update_deck_ui()

@onready var energy_label: Label = $UI/UIHeirarchy/BottomBarNode/BottomBar/EnergyLabel
func update_player_ui() -> void:
	player.update_stats()
	energy_label.text = str(player.energy) + "/" +str(player.max_energy)


func end_turn() -> void:
	if phase != Phase.PLAYER_TURN:
		return
	phase = Phase.PLAYER_TURN_END
	advance_phase()
	turn_number += 1
	
	CombatEffects.proc_effects(player, GlobalEnums.ProcOn.TURN_END)

func advance_phase() -> void:
	match phase:
		Phase.PLAYER_TURN_START:
			
			_do_player_turn_start()
			_resolve_deaths() #
			phase = Phase.PLAYER_TURN

		Phase.PLAYER_TURN_END:
			_do_player_turn_end()
			_resolve_deaths() #
			
			_do_enemy_turn_start()
			_resolve_deaths() 
			_do_enemy_turn()
			_do_enemy_turn_end()
			_resolve_deaths() #
			
			phase = Phase.PLAYER_TURN_START
			advance_phase.call_deferred()


func _resolve_deaths():
	for c in summons.duplicate():
		check_death(c)
	check_death(player)
	for e in enemies.duplicate():
		check_death(e)
		


func _do_player_turn_start():
	_clear_block(player)
	for summon in summons:
		summon.used_this_turn = false
		summon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	CombatEffects.proc_effects(player, GlobalEnums.ProcOn.TURN_START)
	_draw_cards(card_draw_modifier+RunState.card_draw)
	player.energy = player.max_energy
	update_player_ui()
	for summon in summons.duplicate():
		CombatEffects.proc_effects(summon, GlobalEnums.ProcOn.TURN_START)
		_clear_block(summon)
		summon.update_stats()

func _clear_block(creature: Node) -> void:
	creature.block = creature.permanent_block

func _end_combat_loss():
	_return_surviving_summons_to_discard()
	#TODO Run loss animation
	#TODO bring up title screen / game over with some stats eventually
	RunState.scene_history.clear()
	get_tree().change_scene_to_file.call_deferred("res://Scenes/lose.tscn")

func _end_combat_victory() -> void:
	_return_surviving_summons_to_discard()
	for card in deck_manager.hand.duplicate():
		deck_manager.discard(card)
	deck_manager.hand.clear()
	for child in hand_container.get_children():
		child.queue_free()

	RunState.current_hp = player.current_hp
	RunState.map_data.get_current_node().cleared = true
	RunState.push_scene.call_deferred("res://Scenes/RewardManager.tscn")

func _return_surviving_summons_to_discard() -> void:
	for summon in summons.duplicate():
		if summon.card_data == null:
			continue
		var card :CardData= summon.card_data
		card.in_field = false
		deck_manager.summons.erase(card)
		if card in deck_manager.exhaust_pile:
			deck_manager.exhaust_pile.erase(card)
		deck_manager.discard(card)
		summon.queue_free()
	summons.clear()

func check_death(creature: Node):
	if creature == null:
		return
	if creature.current_hp <= 0:
		kill_creature(creature)

func kill_creature(creature: Node) -> void:
	if creature == null:
		return
	if creature.is_queued_for_deletion():
		return
	_mark_dead(creature)

func _mark_dead(creature: Node) -> void:
	if creature == player:
		_request_combat_end(false)
		return

	if creature is SummonCreature:
		_remove_summon(creature)
	elif creature is EnemyCreature:
		_remove_enemy(creature)

func _remove_summon(summon: SummonCreature) -> void:
	summons.erase(summon)

	var card := summon.card_data
	if card != null:
		card.in_field = false
		deck_manager.summons.erase(card)
		deck_manager.discard(card)

	summon.queue_free()

func _remove_enemy(enemy: EnemyCreature) -> void:
	enemies.erase(enemy)
	enemy.queue_free()

	if enemies.is_empty():
		_request_combat_end(true)

var pending_combat_end = null

func _request_combat_end(victory: bool) -> void:
	pending_combat_end = victory

func _process(_delta):
	if pending_combat_end != null:
		if pending_combat_end:
			_end_combat_victory()
		else:
			_end_combat_loss()
		pending_combat_end = null
func _do_enemy_turn_start() -> void:
	for enemy in enemies:
		_clear_block(enemy)
		CombatEffects.proc_effects(enemy, GlobalEnums.ProcOn.TURN_START)

func _do_enemy_turn() -> void:
	for enemy in enemies:
		for a in enemy.data.actions_per_turn:
			_pick_enemy_move(turn_number, enemy)
			_resolve_deaths()
			
		_display_enemy_intent(turn_number, enemy)



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
	var targets :Array[Node] = _get_move_targets(move, enemy)

	CombatEffects.resolve_action(
		enemy,
		targets,
		#TODO CHANGE BELOW TO FIT ATTACK AND BLOCK ONCE ENEMY MOVES UPDATED
		move.value if move.intent_type in [
			GlobalEnums.IntentType.ATTACK,
			GlobalEnums.IntentType.AOEATTACK
		] else 0,
		move.value if move.intent_type == GlobalEnums.IntentType.BLOCK else 0,
		move.target_effects,
		move.self_effects
	)
	for target in targets:
		call_deferred("check_death",target)

func _get_move_targets(move: EnemyMove, enemy) -> Array[Node]:
	var targets:Array[Node]= []
	match move.intent_type:
		GlobalEnums.IntentType.ATTACK, GlobalEnums.IntentType.DEBUFF:
			targets.append(_pick_default_enemy_attack_target())
		GlobalEnums.IntentType.AOEATTACK:
			targets = _target_all_friendlies()
		GlobalEnums.IntentType.BLOCK:
			targets = [enemy]
		_:
			targets = [enemy]
	return targets

func _target_all_friendlies()->Array[Node]:
	var targets :Array[Node] = []
	for sum in summons:
		targets.append(sum)
	targets.append(player)
	return targets


func _pick_default_enemy_attack_target() -> Node:
	var tank := _get_first_alive_in_column(SummonColumn.TANK)
	if tank != null:
		return tank
	var neutral := _get_first_alive_in_column(SummonColumn.NEUTRAL)
	if neutral != null:
		return neutral
	if player.current_hp > 0:
		return player
	var passive := _get_first_alive_in_column(SummonColumn.PASSIVE)
	if passive != null:
		return passive
	return player

func _display_next_intent(move: EnemyMove, enemy: EnemyCreature):
	enemy.display_move(move)
	#TODO Add animation

func _do_player_turn_end():
	CombatEffects.proc_effects(player, GlobalEnums.ProcOn.TURN_END)
	for card in deck_manager.hand.duplicate():
		deck_manager.discard(card)
	deck_manager.hand.clear()
	for child in hand_container.get_children():
		child.queue_free()
	for summon in summons:
		summon.used_this_turn = false
	selected_card = null
	selected_summon = null
	_update_deck_ui()
	for summon in summons.duplicate():
		CombatEffects.proc_effects(summon, GlobalEnums.ProcOn.TURN_END)
		summon.update_stats()
		

func _do_enemy_turn_end():
	for enemy in enemies:
		CombatEffects.proc_effects(enemy, GlobalEnums.ProcOn.TURN_END)


func _on_exhaust_button_pressed() -> void:
	#Visualize exhaust pile
	RunState.open_deck_viewer(self, deck_manager.exhaust_pile, "Exhaust Pile")

func _on_discard_button_pressed() -> void:
	#Visualize discard pile
	RunState.open_deck_viewer(self, deck_manager.discard_pile, "Discard Pile")

func _on_draw_button_pressed() -> void:
	#Visualize draw pile
	RunState.open_deck_viewer(self, deck_manager.draw_pile, "Draw Pile")
