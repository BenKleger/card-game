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
		GlobalEnums.CardColor.BLACK,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 5, 3)
		]
	)
	
	all_cards.append(defend)
	starter_cards.append(defend)
	
	var strike = _card(
		"Strike",
		1,
		GlobalEnums.CardColor.BLACK,
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
			AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.regen(4),2),
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
			_summon("Flagellant", 8, [
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
			_summon("Marrow Thresher", 10, [
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
			_summon("Gore Hound Pack", 8, [
				AF.damage(GlobalEnums.TargetType.ALL_ENEMIES,5,2),
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon The Unforgiven",
		3,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Unforgiven", 12, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,8,3),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.bleed(2),1),
				], false, false)),
		], 
		1,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Revenant Blade",
		2,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Revenant Blade", 8, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,5,2),
				AF.block(GlobalEnums.TargetType.SELF,5,2),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.weak(1),1),
				], false, false)),
		], 
		1,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Ashen Berserker",
		4,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Ashen Berserker", 8, [
				AF.damage(GlobalEnums.TargetType.ALL_ENEMIES,8,3),
				AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.barrier(2),1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.bleed(2),2),
				], false, false)),
		], 
		1,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon The Devourer",
		5,
		GlobalEnums.CardColor.RED,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Devourer", 13, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY,20,5),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.bleed(3),2),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.weak(2),1),
				AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.regen(5),2),
				], false, false)),
		], 
		1,
		GlobalEnums.CardType.FIELD
	))
	
#
	## --- FIELD CARDS: DEFENSIVE (BLUE) ---
	all_cards.append(_card("Summon Shield Warden",
		1,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Shield Warden", 8, [
				AF.block(GlobalEnums.TargetType.PLAYER, 4,2),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))

	all_cards.append(_card("Summon Bone Wall",
		2,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Bone Wall", 10, [
				AF.block(GlobalEnums.TargetType.SELF, 6,3),
				], true, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))

	all_cards.append(_card("Summon Sutured Guard",
		1,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Sutured Guard", 6, [
				AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 3,1),
				AF.effect(GlobalEnums.TargetType.SINGLE_ALLY, EffectLibrary.regen(1), 1),
				], true, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Ash Sentinel",
		2,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Ash Sentinel", 6, [
				AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 6,2),
				], true, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Hollow Knight",
		2,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Hollow Knight", 12, [
				AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 6,3),
				AF.effect(GlobalEnums.TargetType.SINGLE_ALLY, EffectLibrary.barrier(2), 1),
				], true, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Iron Penitent",
		3,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Iron Penitent", 14, [
				AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 12,5),
				], true, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))

	all_cards.append(_card("Summon The Unbroken",
		3,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Unbroken", 16, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 4,2),
				AF.block(GlobalEnums.TargetType.SELF, 8,3),
				], true, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Grave Bulwark",
		2,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Grave Bulwark", 8, [
				AF.effect(GlobalEnums.TargetType.SINGLE_ALLY, EffectLibrary.regen(2), 1),
				AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 8,3),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	all_cards.append(_card("Summon The Last Rampart",
		4,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Last Rampart", 20, [
				AF.effect(GlobalEnums.TargetType.SINGLE_ALLY, EffectLibrary.regen(3), 1),
				AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 18,4),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Deathless Warden",
		5,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Deathless Warden", 28, [
				AF.effect(GlobalEnums.TargetType.SINGLE_ALLY, EffectLibrary.regen(4), 2),
				AF.block(GlobalEnums.TargetType.SINGLE_ALLY, 24,6),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	
	all_cards.append(_card("Summon Goon Cart",
		4,
		GlobalEnums.CardColor.BLUE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Goon Cart", 15, [
				AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
				_summon("Goon", 5, [
					AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 5, 2)
				],true,false, 2,false)),
				], false, true, 5)),
				
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	## --- FIELD CARDS: UTILITY (GREEN) ---
	
	all_cards.append(_card("Summon Crow Scout",
		1,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Crow Scout", 4, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 1,1),
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Scrap Hoarder",
		1,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Scrap Hoarder", 4, [
				AF.gain_energy(GlobalEnums.TargetType.PLAYER, 1,1),
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Remnant Tinkerer",
		2,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Remnant Tinkerer", 7, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 2,1),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
#
	all_cards.append(_card("Summon Void Siphon",
		3,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Void Siphon", 8, [
				AF.gain_energy(GlobalEnums.TargetType.PLAYER, 2,1),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Battleground Salvager",
		2,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Battleground Salvager", 8, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 1,1),
				AF.block(GlobalEnums.TargetType.SELF, 5,2),
				], true, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Bone Harvester",
		3,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Bone Harvester", 10, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 2,1),
				AF.gain_energy(GlobalEnums.TargetType.PLAYER, 1,1),
				], false, false)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon The Chronicler",
		2,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Chronicler", 4, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 3,1),
				], false, true)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Eternal Scavenger",
		4,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Eternal Scavenger", 12, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 3,1),
				AF.gain_energy(GlobalEnums.TargetType.PLAYER, 2,1),
				], false, true, 3)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))

	all_cards.append(_card("Summon The Archivist",
		5,
		GlobalEnums.CardColor.GREEN,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Archivist", 10, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 4,1),
				AF.gain_energy(GlobalEnums.TargetType.PLAYER, 2,1),
				], false, true, 4)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
#
	all_cards.append(_card("Summon The Archivist",
		5,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Archivist", 10, [
				AF.draw(GlobalEnums.TargetType.PLAYER, 4,1),
				AF.gain_energy(GlobalEnums.TargetType.PLAYER, 2,1),
				], false, true, 4)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
#
	## --- FIELD CARDS: CURSED (PURPLE) ---
	
	
	all_cards.append(_card("Power Word Kill",
		3,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.kill(GlobalEnums.TargetType.SINGLE_ENEMY),
			AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.poison(10)),
		],
		1
	))
		
	all_cards.append(_card("Summon Festering Thrall",
		1,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Festering Thrall", 10, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 5, 2),
				AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.bleed(1)),
				], false, false, 2)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Hollow Vessel",
		1,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Hollow Vessel", 8, [
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.vulnerable(1)),
				], false, false, 2)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Spite Engine",
		2,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Spite Engine", 8, [
				AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 3,1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(1),1),
				], false, false, 2)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Rotting Prophet",
		2,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.COMMON,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Rotting Prophet", 12, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 4,2),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.vulnerable(2),1),
				AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.poison(1)),
				], false, true, 4)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Plague Engine",
		3,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Plague Engine", 14, [
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(1),1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.bleed(2),1),
				], false, true, 4)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Desecrator",
		3,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Desecrator", 10, [
				AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 4,2),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.vulnerable(2),1),
				], false, true, 4)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon The Withered",
		2,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Withered", 16, [
				AF.damage(GlobalEnums.TargetType.SINGLE_ENEMY, 6,3),
				AF.effect(GlobalEnums.TargetType.SINGLE_ENEMY, EffectLibrary.weak(2),1),
				AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.bleed(2),1),
				], false, false, 5)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Abyssal Anchor",
		3,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.RARE,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Abyssal Anchor", 14, [
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.vulnerable(2),1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(2),1),
				], false, true, 5)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon The Unraveling",
		4,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("The Unraveling", 12, [
				AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 6,2),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.bleed(3),1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.vulnerable(3),1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(2),1),
				], false, true, 5)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	
	all_cards.append(_card("Summon Void Incarnate",
		5,
		GlobalEnums.CardColor.PURPLE,
		GlobalEnums.CardRarity.LEGENDARY,
		[
			AF.summon(GlobalEnums.TargetType.SUMMON_ALLY,
			_summon("Void Incarnate", 18, [
				AF.damage(GlobalEnums.TargetType.ALL_ENEMIES, 6,2),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.bleed(4),1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.vulnerable(4),1),
				AF.effect(GlobalEnums.TargetType.ALL_ENEMIES, EffectLibrary.weak(3),1),
				AF.effect(GlobalEnums.TargetType.SELF, EffectLibrary.bleed(3)),
				], false, true, 6)),
		], 
		0,
		GlobalEnums.CardType.FIELD
	))
	


func _summon(_name:String = "", hp:int= 1, actions:Array[CombatAction] = [], takes_aggro:bool = false, is_passive:bool=false, hp_up = 0,returned_on_death:bool=true)->SummonData:
	var summon:SummonData = SummonData.new()
	summon.actions = actions
	summon.summon_name = _name
	summon.takes_aggro = takes_aggro
	summon.is_passive = is_passive
	summon.summon_max_hp = hp
	summon.summon_max_hp_up = hp_up
	summon.returned_on_death= returned_on_death
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
