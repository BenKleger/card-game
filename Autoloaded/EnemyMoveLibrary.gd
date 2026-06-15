#EnemyMoveLibrary.gd
extends Node


func _move(actions:Array[CombatAction]) -> EnemyMove:
	var m = EnemyMove.new()
	m.actions = actions
	m.description = ActionLibrary.generate_description(actions)
	return m


var slash = _move([AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,6)])
var feint = _move([AF.block(GlobalEnums.TargetType.SELF,4)])

var gnaw = _move([AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,6),AF.effect(GlobalEnums.TargetType.ALL_ENEMIES,EffectLibrary.bleed(2))])
var frenzy = _move([AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,9)])


var scrounge = _move([AF.damage(GlobalEnums.TargetType.ALL_ENEMIES,3)])
var cower = _move([AF.block(GlobalEnums.TargetType.ALL_ALLIES,3)])


var flagellate = _move([AF.damage(GlobalEnums.TargetType.ALL_ENEMIES,5),AF.effect(GlobalEnums.TargetType.ALL_ENEMIES,EffectLibrary.bleed(2))])
var suffer = _move([AF.block(GlobalEnums.TargetType.SELF,5),AF.effect(GlobalEnums.TargetType.SELF,EffectLibrary.barrier(4))])
var repent = _move([AF.damage(GlobalEnums.TargetType.ALL_ENEMIES,10)])

var lash = _move([AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 7),AF.effect(GlobalEnums.TargetType.ALL_ENEMIES,EffectLibrary.bleed(2))])
var fortify = _move([AF.block(GlobalEnums.TargetType.SELF,8),AF.effect(GlobalEnums.TargetType.SELF,EffectLibrary.barrier(5))])
var decree = _move([AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.burn(5))])


var choke = _move([AF.damage(GlobalEnums.TargetType.PLAYER, 15)])
var writhe = _move([AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(2)),AF.block(GlobalEnums.TargetType.SELF, 7)])
var thrash = _move([AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 7)])
var mend = _move([AF.heal(GlobalEnums.TargetType.ALL_ALLIES, 12)])


var cleave = _move([AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 14)])
var suture = _move([AF.heal(GlobalEnums.TargetType.SELF, 20)])
var unravel = _move([AF.damage(GlobalEnums.TargetType.PLAYER, 20)])
var proclamation = _move([AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.frail(5)),AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(5)),
#AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.poison(5)) #seems a bit too op
])
