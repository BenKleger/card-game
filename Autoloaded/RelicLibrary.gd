# RelicLibrary.gd — autoload
extends Node

var all_relics: Array[RelicData] = []

func _ready() -> void:
	_build_relics()

func get_relics_by_rarity(rarity: GlobalEnums.CardRarity) -> Array[RelicData]:
	return all_relics.filter(func(r): return r.rarity == rarity)

func _build_relics() -> void:
	# --- Common ---
	all_relics.append(_relic("Cracked Fang", "Gain 1 max HP per turn.", GlobalEnums.CardRarity.COMMON, 
		func(): RunState.max_hp += 1))
	
	all_relics.append(_relic("Soiled Bandage", "Heal 2 HP at the start of each turn.", GlobalEnums.CardRarity.COMMON,
		func(): pass))  # triggers via effect
	
	all_relics.append(_relic("Bottled Spite", "Cards cost 1 less energy. Minimum 0.", GlobalEnums.CardRarity.COMMON,
		func(): RunState.card_energy_reduction = 1))
	
	all_relics.append(_relic("Rust-Eaten Locket", "Draw an extra card each turn.", GlobalEnums.CardRarity.COMMON,
		func(): RunState.card_draw += 1))
	
	all_relics.append(_relic("Vial of Ash", "Enemies deal 1 less damage to you. Minimum 1.", GlobalEnums.CardRarity.COMMON,
		func(): RunState.damage_reduction = 1))
	
	all_relics.append(_relic("Scar Tissue", "Gain 10 max HP.", GlobalEnums.CardRarity.COMMON,
		func(): RunState.max_hp += 10))
	
	# --- Rare ---
	all_relics.append(_relic("Sutured Heart", "Whenever you take damage, gain 1 strength.", GlobalEnums.CardRarity.RARE,
		func(): pass))  # effect-based
	
	all_relics.append(_relic("Prisoner's Chain", "Start each combat with 1 strength stacked.", GlobalEnums.CardRarity.RARE,
		func(): 
			var strength = EffectStrength.new()
			strength.stacks = 1
			strength.on_obtained(RunState)  # or apply it to player at combat start
			))
	
	all_relics.append(_relic("Plague Mask", "Enemies apply 1 less bleed when they attack.", GlobalEnums.CardRarity.RARE,
		func(): RunState.enemy_bleed_reduction = 1))
	
	all_relics.append(_relic("Hollow Bone", "Your attacks ignore 3 block.", GlobalEnums.CardRarity.RARE,
		func(): RunState.block_pierce = 3))
	
	all_relics.append(_relic("Corpse-Eater's Tooth", "Gain 5 gold for each enemy defeated.", GlobalEnums.CardRarity.RARE,
		func(): RunState.gold_per_kill = 5))
	
	all_relics.append(_relic("Thorn Wrapping", "Whenever an enemy attacks, deal 2 damage back.", GlobalEnums.CardRarity.RARE,
		func(): pass))  # effect-based
	
	all_relics.append(_relic("Obsidian Eye", "You see 2 turns ahead of enemies instead of 1.", GlobalEnums.CardRarity.RARE,
		func(): RunState.look_ahead_turns = 2))
	
	all_relics.append(_relic("Widow's Silk", "Enemies have a 25% chance to miss their attack.", GlobalEnums.CardRarity.RARE,
		func(): RunState.enemy_miss_chance = 0.25))
	
	# --- Legendary ---
	all_relics.append(_relic("The Scarred Crown", "At the start of each combat, gain 2 strength and 2 vulnerable stacks.", GlobalEnums.CardRarity.LEGENDARY,
		func(): pass))  # combat hook
	
	all_relics.append(_relic("Chronometer Heart", "Rewind a combat encounter once per run. Boss mutates on rewind.", GlobalEnums.CardRarity.LEGENDARY,
		func(): RunState.rewind_available = true))
	
	all_relics.append(_relic("Deathless Covenant", "Once per run, survive lethal damage with 1 HP instead.", GlobalEnums.CardRarity.LEGENDARY,
		func(): RunState.death_save_available = true))
	
	all_relics.append(_relic("Feast of Crows", "Every third enemy defeated, draw 3 cards.", GlobalEnums.CardRarity.LEGENDARY,
		func(): RunState.feast_threshold = 3))
	
	all_relics.append(_relic("Unraveling Bind", "Whenever you play a card, apply 1 weak to all enemies.", GlobalEnums.CardRarity.LEGENDARY,
		func(): RunState.weak_on_play = true))
	
	all_relics.append(_relic("The Stitch", "Permanently gain +5 max HP. Gain an additional 1 max HP per floor cleared.", GlobalEnums.CardRarity.LEGENDARY,
		func(): RunState.max_hp += 5))

func _relic(name: String, desc: String, rarity: GlobalEnums.CardRarity, on_collect: Callable) -> RelicData:
	var r = RelicData.new()
	r.relic_name = name
	r.description = desc
	r.rarity = rarity
	r.on_collected = on_collect 
	return r
