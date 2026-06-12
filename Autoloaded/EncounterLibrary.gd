# EncounterLibrary.gd — autoload
extends Node

static var _next_uid: int = 0


var ALL_COMBAT: Array[EncounterData] = []
var ALL_ELITE: Array[EncounterData] = []
var ALL_BOSS: Array[EncounterData] = []

func _ready() -> void:
	_build_enemies()

func get_encounters_for_type(type: GlobalEnums.MapNodeType, rng: RandomNumberGenerator) -> EncounterData:
	match type:
		GlobalEnums.MapNodeType.COMBAT:
			return ALL_COMBAT[rng.randi_range(0, ALL_COMBAT.size() - 1)]
		GlobalEnums.MapNodeType.ELITE:
			if ALL_ELITE.is_empty():
				return ALL_COMBAT[rng.randi_range(0, ALL_COMBAT.size() - 1)]
			return ALL_ELITE[rng.randi_range(0, ALL_ELITE.size() - 1)]
		GlobalEnums.MapNodeType.BOSS:
			if ALL_BOSS.is_empty():
				return ALL_COMBAT[rng.randi_range(0, ALL_COMBAT.size() - 1)]
			return ALL_BOSS[rng.randi_range(0, ALL_BOSS.size() - 1)]
		_:
			return null

# --- Builders ---
func _build_enemies() -> void:
	ALL_COMBAT = [
		_encounter("Ashwalker Scout", [_ashwalker_scout()]),
		_encounter("Rot Hound", [_rot_hound()]),
		_encounter("Scavenger Pair", [_scavenger(), _scavenger()]),
		_encounter("Hollow Penitent", [_hollow_penitent()]),
		_encounter("Ashwalker and Hound", [_ashwalker_scout(), _rot_hound()]),
	]
	ALL_ELITE = [
		_encounter("Flayed Warden", [_flayed_warden()]),
		_encounter("The Twice-Hanged", [_twice_hanged()]),
	]
	ALL_BOSS = [
		_encounter("The Sutured King", [_sutured_king()]),
	]

func _encounter(encounter_name: String, enemy_list: Array[EnemyData]) -> EncounterData:
	var e = EncounterData.new()
	e.encounter_name = encounter_name
	e.enemies = enemy_list
	return e

func _enemy(enemy_name: String, hp: int, starting: Array[EnemyMove], loop: Array[EnemyMove]) -> EnemyData:
	var e = EnemyData.new()
	e.uid = _next_uid
	_next_uid += 1
	e.enemy_name = enemy_name
	e.base_hp = hp
	e.starting_moves = starting
	e.move_pool_loop = loop
	return e

func _move(intent: GlobalEnums.IntentType, val: int, desc: String,effects_on_target:Array[Effect] = [], effects_on_self:Array[Effect]=[]) -> EnemyMove:
	var m = EnemyMove.new()
	m.intent_type = intent
	m.value = val
	m.description = desc
	m.target_effects = effects_on_target
	m.self_effects = effects_on_self
	return m

# --- Combat enemies ---
func _ashwalker_scout() -> EnemyData:
	var slash = _move(GlobalEnums.IntentType.ATTACK, 6, "Deals 6 damage")
	var feint = _move(GlobalEnums.IntentType.BLOCK, 4, "Gains 4 block")
	return _enemy("Ashwalker Scout", 18, [slash], [slash, feint, slash])

func _rot_hound() -> EnemyData:
	var gnaw = _move(GlobalEnums.IntentType.AOEATTACK, 4, "Deals 4 damage",  [EffectLibrary.bleed(2)],[EffectLibrary.regen(2)])
	var frenzy = _move(GlobalEnums.IntentType.ATTACK, 8, "Deals 8 damage")
	return _enemy("Rot Hound", 14, [gnaw], [gnaw, gnaw, frenzy])

func _scavenger() -> EnemyData:
	var scrounge = _move(GlobalEnums.IntentType.ATTACK, 3, "Deals 3 damage")
	var cower = _move(GlobalEnums.IntentType.BLOCK, 6, "Gains 6 block")
	return _enemy("Scavenger", 10, [cower], [scrounge, cower, scrounge, scrounge])

func _hollow_penitent() -> EnemyData:
	var flagellate = _move(GlobalEnums.IntentType.ATTACK, 5, "Deals 5 damage")
	var suffer = _move(GlobalEnums.IntentType.BUFF, 0, "Braces for suffering")
	var repent = _move(GlobalEnums.IntentType.ATTACK, 10, "Deals 10 damage")
	return _enemy("Hollow Penitent", 24, [suffer], [flagellate, flagellate, suffer, repent])

# --- Elite enemies ---
func _flayed_warden() -> EnemyData:
	var lash = _move(GlobalEnums.IntentType.ATTACK, 9, "Deals 9 damage")
	var fortify = _move(GlobalEnums.IntentType.BLOCK, 12, "Gains 12 block")
	var decree = _move(GlobalEnums.IntentType.DEBUFF, 0, "Issues a decree of pain")
	return _enemy("Flayed Warden", 48, [fortify], [lash, lash, fortify, decree, lash])

func _twice_hanged() -> EnemyData:
	var choke = _move(GlobalEnums.IntentType.ATTACK, 7, "Deals 7 damage")
	var writhe = _move(GlobalEnums.IntentType.DEBUFF, 0, "Writhes violently")
	var thrash = _move(GlobalEnums.IntentType.ATTACK, 14, "Deals 14 damage")
	var mend = _move(GlobalEnums.IntentType.BUFF, 0, "Knits flesh back together")
	return _enemy("The Twice-Hanged", 60, [writhe], [choke, choke, writhe, thrash, mend, choke])

# --- Boss ---
func _sutured_king() -> EnemyData:
	var cleave = _move(GlobalEnums.IntentType.ATTACK, 14, "Deals 14 damage")
	var suture = _move(GlobalEnums.IntentType.BUFF, 0, "Stitches wounds closed")
	var unravel = _move(GlobalEnums.IntentType.ATTACK, 20, "Deals 20 damage")
	var proclamation = _move(GlobalEnums.IntentType.DEBUFF, 0, "Crown proclamation weakens you")
	return _enemy("The Sutured King", 120, [suture], [cleave, cleave, suture, cleave, unravel, proclamation])
