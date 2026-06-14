# CardLibrary.gd — autoload
extends Node

var all_cards: Array[CardData] = []
var starter_cards:Array[CardData] = [] # Cards not given in rewards
func non_starter_cards()-> Array[CardData]:
	var cards :Array[CardData] = []
	for card in all_cards:
		if card not in starter_cards:
			cards.append(card)
	return cards

func _ready() -> void:
	_build_cards()

func get_cards_by_rarity(rarity: GlobalEnums.CardRarity) -> Array[CardData]:
	return non_starter_cards().filter(func(c): return c.rarity == rarity)

func get_cards_by_color(color: GlobalEnums.CardColor) -> Array[CardData]:
	return non_starter_cards().filter(func(c): return c.color == color)

func _build_cards() -> void: #TODO Overhaul to also accept upgrades
	var defend = _card(
		"Defend",
		1,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.block(GlobalEnums.TargetType.SELF, 5, 3)
		]
	)
	
	all_cards.append(defend)
	starter_cards.append(defend)
	
	var strike = _card(
		"Strike",
		1,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 6, 3)
		]
	)
	all_cards.append(strike)
	starter_cards.append(strike)

	all_cards.append(_card("Cleave",
		1,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 6, 2)
		]
	))

	all_cards.append(_card("Hemorrhage",
		1,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 4, 2),
			AF.effect(
				GlobalEnums.TargetType.SINGLE_ENEMY,
				EffectLibrary.bleed(2),
				1
			)
		]
	))

	all_cards.append(_card("Bloodlust",
		1,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.RARE,
		[
			AF.effect(
				GlobalEnums.TargetType.SELF,
				EffectLibrary.strength(2),
				1
			)
		]
	))

	all_cards.append(_card("Brace",
		1,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.block(GlobalEnums.TargetType.SELF, 8, 3)
		]
	))

	all_cards.append(_card("Mend",
		1,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.block(GlobalEnums.TargetType.SELF, 4, 2),
			AF.effect(
				GlobalEnums.TargetType.SELF,
				EffectLibrary.regen(1),
				1
			)
		]
	))

	all_cards.append(_card("Surge",
		0,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.gain_energy(
				GlobalEnums.TargetType.SELF,
				1,
				1
			)
		]
	))

	all_cards.append(_card("Scratch",
		1,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,3,2),
			AF.draw(GlobalEnums.TargetType.SELF, 1, 1)
		]
	))
	
	# --- Colorless — starter cards, available to all ---
	all_cards.append(_card("Carve",
		2,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.RARE,
		[
			AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 8, 3),
			AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.bleed(2))
		]
	))
	
	all_cards.append(_card("Sever",
		3,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 20, 6),
			AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.bleed(5), 2),
			AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(2), 1)
		]
	))
	
	## --- BLUE cards — defensive, block, regen, control ---
	
	all_cards.append(_card("Iron Skin",
		2,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.block(GlobalEnums.TargetType.SELF, 14, 4)
		]
	))
	
	all_cards.append(_card("Parry",
		0,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.block(GlobalEnums.TargetType.SELF, 4, 2)
		]
	))
	
	all_cards.append(_card("Bulwark",
		2,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.block(GlobalEnums.TargetType.SELF, 10, 3),
			AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.barrier(2), 1)
		]
	))
	
	all_cards.append(_card("Counter",
		1,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.block(GlobalEnums.TargetType.SELF, 6, 2),
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 6, 2)
		]
	))
	
	all_cards.append(_card("Aegis",
		3,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.block(GlobalEnums.TargetType.SELF, 20, 6),
			AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.regen(4), 1),
		]
	))
	
	## --- GREEN cards — draw, energy, tempo ---
	#
	all_cards.append(_card("Surge",
		0,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.gain_energy(GlobalEnums.TargetType.PLAYER,1,1),
		]
	))

	all_cards.append(_card("Scratch",
		1,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 4, 1),
			AF.draw(GlobalEnums.TargetType.PLAYER, 1, 1),
		]
	))
	
	all_cards.append(_card("Adrenaline",
		2,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.RARE,
		[
			AF.draw(GlobalEnums.TargetType.PLAYER, 2, 1),
			AF.gain_energy(GlobalEnums.TargetType.PLAYER, 2, 0)
		],
		1
	))
	all_cards.append(_card("Windfall",
		1,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.RARE,
		[
			AF.draw(GlobalEnums.TargetType.PLAYER, 4),
		],
		1
	))
	
	all_cards.append(_card("Cascade",
		3,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.draw(GlobalEnums.TargetType.PLAYER, 5, 1),
			AF.gain_energy(GlobalEnums.TargetType.PLAYER, 2, 0)
		],
		1
	))
#
	## --- PURPLE cards — debuffs, vulnerable, disruption ---
	
	all_cards.append(_card("Enfeeble",
		1,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.weak(2), 1),
		],
		1
	))
	
	all_cards.append(_card("Expose",
		1,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 3, 1),
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.vulnerable(2), 1),
		],
		1
	))
	
	all_cards.append(_card("Unnerve",
		0,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.weak(1),1),
		]
	))
	
	all_cards.append(_card("Rot",
		1,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 4, 1),
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.bleed(1),1),
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.weak(1),1),
		]
	))
	
	all_cards.append(_card("Shatter",
		2,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 6, 2),
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.vulnerable(3),1),
		]
	))
	
	all_cards.append(_card("Plague",
		2,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.poison(2),1),
			AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.weak(2),1),
		]
	))
	
	all_cards.append(_card("Unravel",
		3,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 8, 3),
			AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.vulnerable(3),1),
			AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(3),1),
		]
	))
	
	## --- FIELD CARDS: AGGRESSIVE (RED) ---

	all_cards.append(_card("Summon Flagellant",
		3,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Flagellant", 2, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,6,2),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY,EffectLibrary.bleed(1), 1)
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	
	all_cards.append(_card("Summon Defender",
		1,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Defender", 2, [AF.block(GlobalEnums.TargetType.SINGLE_ALLY,3,4)], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	

	all_cards.append(_card("Summon Warden",
		1,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Warden", 5, [AF.block(GlobalEnums.TargetType.SELF,6,2)], true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
#
	all_cards.append(_card("Summon Flagellant",
		2,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Flagellant", 4, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,4,1),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY,EffectLibrary.bleed(2), 1)
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Bone Archer",
		1,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Bone Archer", 4, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,4,2),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Plague Bearer",
		2,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Plague Bearer", 4, [
				AF.damage(GlobalEnums.TargetType.ALL_ENEMIES,2,1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES,EffectLibrary.bleed(2), 1)
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Marrow Thresher",
		2,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Marrow Thresher", 6, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,10,3),
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Gore Hound Pack",
		2,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Gore Hound Pack", 4, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,10,3),
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	#all_cards.append(_card("Gore Hound Pack", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.ALL_ENEMIES, 3, 0, 0, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Unforgiven", 3, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.SINGLE_ENEMY, 8, 0, 0, 0, 0, [_bleed(2)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Revenant Blade", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.SINGLE_ENEMY, 5, 0, 0, 0, 0, [_weak(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Ashen Berserker", 4, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.ALL_ENEMIES, 8, 0, 0, 0, 0, [_bleed(2)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Devourer", 5, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.SINGLE_ENEMY, 20, 0, 0, 0, 0, [_bleed(3), _weak(2)], GlobalEnums.CardType.FIELD))
#
	## --- FIELD CARDS: DEFENSIVE (BLUE) ---
	#all_cards.append(_card("Shield Warden", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.SELF, 0, 4, 0, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Bone Wall", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.SELF, 0, 6, 0, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Sutured Guard", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.SELF, 0, 3, 0, 0, 0, [_regen(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Ash Sentinel", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.SELF, 0, 5, 0, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Hollow Knight", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.SELF, 0, 8, 0, 0, 0, [_regen(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Iron Penitent", 3, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.SELF, 0, 12, 0, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Unbroken", 3, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.SELF, 2, 8, 0, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Grave Bulwark", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.SELF, 0, 7, 0, 0, 0, [_regen(2)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Last Rampart", 4, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.SELF, 0, 18, 0, 0, 0, [_regen(3)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Deathless Warden", 5, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.SELF, 0, 24, 0, 0, 0, [_regen(4)], GlobalEnums.CardType.FIELD))
#
	## --- FIELD CARDS: UTILITY (GREEN) ---
	#all_cards.append(_card("Crow Scout", 1, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.NONE, 0, 0, 1, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Scrap Hoarder", 1, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.NONE, 0, 0, 0, 1, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Ash Wanderer", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.NONE, 0, 0, 1, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Remnant Tinkerer", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.NONE, 0, 0, 2, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Void Siphon", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.NONE, 0, 0, 0, 2, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Ruin Salvager", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.NONE, 0, 2, 1, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Bone Harvester", 3, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.NONE, 0, 0, 2, 1, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Chronicler", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.NONE, 0, 0, 3, 0, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Eternal Scavenger", 4, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.NONE, 0, 0, 3, 2, 0, [], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Archivist", 5, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.NONE, 0, 0, 4, 2, 0, [], GlobalEnums.CardType.FIELD))
#
	## --- FIELD CARDS: CURSED (PURPLE) ---
	#all_cards.append(_card("Festering Thrall", 1, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.SINGLE_ENEMY, 5, 0, 0, 0, 0, [_bleed_self(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Hollow Vessel", 1, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_vulnerable(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Spite Engine", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.ALL_ENEMIES, 3, 0, 0, 0, 0, [_weak(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Rotting Prophet", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		#CardData.TargetType.SINGLE_ENEMY, 4, 0, 0, 0, 0, [_vulnerable(1), _bleed_self(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Plague Engine", 3, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_bleed(2), _weak(1)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Desecrator", 3, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.ALL_ENEMIES, 4, 0, 0, 0, 0, [_vulnerable(2)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Withered", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.SINGLE_ENEMY, 6, 0, 0, 0, 0, [_weak(2), _bleed_self(2)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Abyssal Anchor", 3, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		#CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_vulnerable(2), _weak(2)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("The Unraveling", 5, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.ALL_ENEMIES, 6, 0, 0, 0, 0, [_bleed(3), _vulnerable(3), _weak(2)], GlobalEnums.CardType.FIELD))
#
	#all_cards.append(_card("Void Incarnate", 5, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.LEGENDARY,
		#CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_bleed(4), _vulnerable(4), _weak(3), _bleed_self(3)], GlobalEnums.CardType.FIELD))


func _summon(_name:String = "", hp:int= 1, actions:Array[CombatAction] = [], takes_aggro:bool = false, is_passive:bool=false)->SummonData:
	var summon:SummonData = SummonData.new()
	summon.actions = actions
	summon.summon_name = _name
	summon.takes_aggro = takes_aggro
	summon.is_passive = is_passive
	summon.summon_max_hp = hp
	return summon

static var _next_uid: int = 0
func get_next_uid():
	_next_uid += 1
	return _next_uid

func _card(
	_name: String,
	cost: int,
	color: GlobalEnums.CardColor,
	rarity: GlobalEnums.CardRarity,
	actions: Array[CombatAction],
	cost_up: int = 0,
	type: GlobalEnums.CardType = GlobalEnums.CardType.PERMANENT,
) -> CardData:

	var card := CardData.new()
	
	card.uid = get_next_uid()
	card.card_name = _name
	card.energy_cost = cost
	card.energy_cost_upgrade = cost_up
	card.color = color
	card.rarity = rarity
	card.actions = actions
	card.card_type = type

	card.description = ActionLibrary.generate_description(actions)

	return card
