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

# --- Combat enemies ---
func _ashwalker_scout() -> EnemyData:
	return _enemy("Ashwalker Scout", 18, [EnemyMoveLibrary.slash], [EnemyMoveLibrary.slash, EnemyMoveLibrary.feint, EnemyMoveLibrary.slash])

func _rot_hound() -> EnemyData:
	return _enemy("Rot Hound", 14, [EnemyMoveLibrary.gnaw], [EnemyMoveLibrary.gnaw, EnemyMoveLibrary.gnaw, EnemyMoveLibrary.frenzy])

func _scavenger() -> EnemyData:
	return _enemy("Scavenger", 10, [EnemyMoveLibrary.cower], [EnemyMoveLibrary.scrounge, EnemyMoveLibrary.cower, EnemyMoveLibrary.scrounge, EnemyMoveLibrary.scrounge])

func _hollow_penitent() -> EnemyData:
	return _enemy("Hollow Penitent", 24, [EnemyMoveLibrary.suffer], [EnemyMoveLibrary.flagellate, EnemyMoveLibrary.flagellate, EnemyMoveLibrary.suffer, EnemyMoveLibrary.repent])

# --- Elite enemies ---
func _flayed_warden() -> EnemyData:
	return _enemy("Flayed Warden", 48, [EnemyMoveLibrary.fortify], [EnemyMoveLibrary.lash, EnemyMoveLibrary.lash, EnemyMoveLibrary.fortify, EnemyMoveLibrary.decree, EnemyMoveLibrary.lash])

func _twice_hanged() -> EnemyData:
	return _enemy("The Twice-Hanged", 60, [EnemyMoveLibrary.writhe], [EnemyMoveLibrary.choke, EnemyMoveLibrary.choke, EnemyMoveLibrary.writhe,EnemyMoveLibrary.thrash,EnemyMoveLibrary.mend, EnemyMoveLibrary.choke])

# --- Boss ---
func _sutured_king() -> EnemyData:
	
	return _enemy("The Sutured King", 120, [EnemyMoveLibrary.suture], [EnemyMoveLibrary.cleave, EnemyMoveLibrary.cleave, EnemyMoveLibrary.suture, EnemyMoveLibrary.cleave, EnemyMoveLibrary.unravel, EnemyMoveLibrary.proclamation])
