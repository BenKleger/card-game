# CardLibrary.gd — autoload
extends Node

var all_cards: Array[CardData] = []
var omitted_cards:Array[CardData] = [] # Cards not given in rewards
func get_reward_cards()-> Array[CardData]:
	var cards :Array[CardData] = []
	for card in all_cards:
		if card not in omitted_cards:
			cards.append(card)
	return cards

func _ready() -> void:
	_build_cards()

func generate_description(card: CardData) -> String:
	var desc := ""
	if card.damage > 0:
		desc += str(card.damage) + " Damage\n"
	if card.block > 0:
		desc += str(card.block) + " Block\n"
	if card.draw > 0:
		desc += str(card.draw) + " Draw\n"
	if card.energy_gain > 0:
		desc += str(card.energy_gain) + " Energy\n"
	for effect in card.target_effects:
		if effect != null:
			desc += effect.name + " " + str(effect.stacks) + " Target\n"
	for effect in card.self_effects:
		if effect != null:
			desc += effect.name + " " + str(effect.stacks) + " Self\n"
	
	return desc

func get_cards_by_rarity(rarity: GlobalEnums.CardRarity) -> Array[CardData]:
	return all_cards.filter(func(c): return c.rarity == rarity)

func get_cards_by_color(color: GlobalEnums.CardColor) -> Array[CardData]:
	return all_cards.filter(func(c): return c.color == color)

func _build_cards() -> void:
	all_cards.append(_card("Defend", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 5, 0, 0, 0, []))
	
	all_cards.append(_card("Strike", 1, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 6, 0, 0, 0, 0, []))
	
	all_cards.append(_card("Rabid Hound", 1, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 4, 0, 0, 0, 0, [], GlobalEnums.CardType.FIELD, 5, true, false))
	all_cards.append(_card("Shitty", 1, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ALLY , 0, 5, 0, 0, 0, [], GlobalEnums.CardType.FIELD, 5, false, true))
	
	# --- Colorless — starter cards, available to all ---

	
	# --- RED cards — aggressive, high damage, self-damage, bleed ---
	all_cards.append(_card("Cleave", 1, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.ALL_ENEMIES, 6, 0, 0, 0, 0, []))
	
	all_cards.append(_card("Hemorrhage", 1, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 4, 0, 0, 0, 0, [_bleed(2)]))
	
	all_cards.append(_card("Reckless Strike", 0, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 10, 0, 0, 0, 0, [_bleed_self(2)]))
	
	all_cards.append(_card("Gore", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 8, 0, 0, 0, 0, [_bleed(3)]))
	
	all_cards.append(_card("Bloodlust", 1, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SELF, 0, 0, 0, 0, 0, [_strength(2)]))
	
	all_cards.append(_card("Carve", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.ALL_ENEMIES, 8, 0, 0, 0, 0, [_bleed(2)]))
	
	all_cards.append(_card("Sever", 3, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.SINGLE_ENEMY, 20, 0, 0, 0, 0, [_bleed(5), _weak(2)]))

	# --- BLUE cards — defensive, block, regen, control ---
	all_cards.append(_card("Brace", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 8, 0, 0, 0, []))
	
	all_cards.append(_card("Mend", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 4, 0, 0, 0, [_regen(1)]))
	
	all_cards.append(_card("Iron Skin", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 14, 0, 0, 0, []))
	
	all_cards.append(_card("Parry", 0, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 4, 0, 0, 0, []))
	
	all_cards.append(_card("Bulwark", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SELF, 0, 18, 0, 0, 0, [_regen(2)]))
	
	all_cards.append(_card("Counter", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SINGLE_ENEMY, 6, 6, 0, 0, 0, []))
	
	all_cards.append(_card("Aegis", 3, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.SELF, 0, 30, 0, 0, 0, [_regen(4)]))

	# --- GREEN cards — draw, energy, tempo ---
	
	all_cards.append(_card("Surge", 0, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.NONE, 0, 0, 0, 1, 0, []))
	
	all_cards.append(_card("Scratch", 1, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 3, 0, 1, 0, 0, []))
	
	all_cards.append(_card("Rummage", 1, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.NONE, 0, 0, 3, 0, 0, []))
	
	all_cards.append(_card("Adrenaline", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.NONE, 0, 0, 2, 2, 0, []))
	
	all_cards.append(_card("Windfall", 1, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.NONE, 0, 0, 4, 0, 0, []))
	
	all_cards.append(_card("Cascade", 3, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.NONE, 0, 0, 5, 2, 0, []))

	# --- PURPLE cards — debuffs, vulnerable, disruption ---
	all_cards.append(_card("Enfeeble", 1, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 0, 0, 0, 0, 0, [_weak(2)]))
	
	all_cards.append(_card("Expose", 1, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 3, 0, 0, 0, 0, [_vulnerable(2)]))
	
	all_cards.append(_card("Unnerve", 0, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 0, 0, 0, 0, 0, [_weak(1)]))
	
	all_cards.append(_card("Rot", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 4, 0, 0, 0, 0, [_bleed(2), _weak(1)]))
	
	all_cards.append(_card("Shatter", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SINGLE_ENEMY, 6, 0, 0, 0, 0, [_vulnerable(3)]))
	
	all_cards.append(_card("Plague", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_bleed(2), _weak(2)]))
	
	all_cards.append(_card("Unravel", 3, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.ALL_ENEMIES, 8, 0, 0, 0, 0, [_vulnerable(3), _weak(3)]))

	# --- FIELD CARDS: AGGRESSIVE (RED) ---

	all_cards.append(_card("Flagellant", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 6, 0, 0, 0, 0, [_bleed(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Bone Archer", 1, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 3, 0, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Plague Bearer", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.ALL_ENEMIES, 2, 0, 0, 0, 0, [_bleed(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Marrow Thresher", 3, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SINGLE_ENEMY, 10, 0, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Gore Hound Pack", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.ALL_ENEMIES, 3, 0, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Unforgiven", 3, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SINGLE_ENEMY, 8, 0, 0, 0, 0, [_bleed(2)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Revenant Blade", 2, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SINGLE_ENEMY, 5, 0, 0, 0, 0, [_weak(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Ashen Berserker", 4, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.ALL_ENEMIES, 8, 0, 0, 0, 0, [_bleed(2)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Devourer", 5, GlobalEnums.CardColor.RED, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.SINGLE_ENEMY, 20, 0, 0, 0, 0, [_bleed(3), _weak(2)], GlobalEnums.CardType.FIELD))

	# --- FIELD CARDS: DEFENSIVE (BLUE) ---
	all_cards.append(_card("Shield Warden", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 4, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Bone Wall", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 6, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Sutured Guard", 1, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 3, 0, 0, 0, [_regen(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Ash Sentinel", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SELF, 0, 5, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Hollow Knight", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SELF, 0, 8, 0, 0, 0, [_regen(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Iron Penitent", 3, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SELF, 0, 12, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Unbroken", 3, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SELF, 2, 8, 0, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Grave Bulwark", 2, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SELF, 0, 7, 0, 0, 0, [_regen(2)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Last Rampart", 4, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.SELF, 0, 18, 0, 0, 0, [_regen(3)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Deathless Warden", 5, GlobalEnums.CardColor.BLUE, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.SELF, 0, 24, 0, 0, 0, [_regen(4)], GlobalEnums.CardType.FIELD))

	# --- FIELD CARDS: UTILITY (GREEN) ---
	all_cards.append(_card("Crow Scout", 1, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.NONE, 0, 0, 1, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Scrap Hoarder", 1, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.NONE, 0, 0, 0, 1, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Ash Wanderer", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.NONE, 0, 0, 1, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Remnant Tinkerer", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.NONE, 0, 0, 2, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Void Siphon", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.NONE, 0, 0, 0, 2, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Ruin Salvager", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.NONE, 0, 2, 1, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Bone Harvester", 3, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.NONE, 0, 0, 2, 1, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Chronicler", 2, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.NONE, 0, 0, 3, 0, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Eternal Scavenger", 4, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.NONE, 0, 0, 3, 2, 0, [], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Archivist", 5, GlobalEnums.CardColor.GREEN, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.NONE, 0, 0, 4, 2, 0, [], GlobalEnums.CardType.FIELD))

	# --- FIELD CARDS: CURSED (PURPLE) ---
	all_cards.append(_card("Festering Thrall", 1, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 5, 0, 0, 0, 0, [_bleed_self(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Hollow Vessel", 1, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_vulnerable(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Spite Engine", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.ALL_ENEMIES, 3, 0, 0, 0, 0, [_weak(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Rotting Prophet", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.COMMON,
		CardData.TargetType.SINGLE_ENEMY, 4, 0, 0, 0, 0, [_vulnerable(1), _bleed_self(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Plague Engine", 3, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_bleed(2), _weak(1)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Desecrator", 3, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.ALL_ENEMIES, 4, 0, 0, 0, 0, [_vulnerable(2)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Withered", 2, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.SINGLE_ENEMY, 6, 0, 0, 0, 0, [_weak(2), _bleed_self(2)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Abyssal Anchor", 3, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.RARE,
		CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_vulnerable(2), _weak(2)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("The Unraveling", 5, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.ALL_ENEMIES, 6, 0, 0, 0, 0, [_bleed(3), _vulnerable(3), _weak(2)], GlobalEnums.CardType.FIELD))

	all_cards.append(_card("Void Incarnate", 5, GlobalEnums.CardColor.PURPLE, GlobalEnums.CardRarity.LEGENDARY,
		CardData.TargetType.ALL_ENEMIES, 0, 0, 0, 0, 0, [_bleed(4), _vulnerable(4), _weak(3), _bleed_self(3)], GlobalEnums.CardType.FIELD))

# --- Card factory ---

static var _next_uid: int = 0
func get_next_uid():
	_next_uid += 1
	return _next_uid
	
func _card(
	card_name: String,
	cost: int,
	color: GlobalEnums.CardColor,
	rarity: GlobalEnums.CardRarity,
	target_type: CardData.TargetType,
	damage: int,
	block: int,
	draw: int,
	energy_gain: int,
	coin_gain: int,
	effects: Array[Effect],
	card_type :GlobalEnums.CardType = GlobalEnums.CardType.PERMANENT,
	summon_hp: int = 1,
	takes_aggro: bool = false,
	is_passive: bool = false,
	self_effects:Array[Effect] = []
) -> CardData:
	var c = CardData.new()
	c.uid = get_next_uid()
	c.card_name = card_name
	c.energy_cost = cost
	c.color = color
	c.rarity = rarity
	c.target_type = target_type
	c.damage = damage
	c.block = block
	c.draw = draw
	c.energy_gain = energy_gain
	c.coin_gain = coin_gain
	c.target_effects = effects
	c.self_effects = self_effects
	c.description = _generate_description(damage, block, draw, energy_gain, effects)
	c.card_type = card_type
	c.summon_hp = summon_hp
	c.takes_aggro = takes_aggro
	c.is_passive = is_passive
	return c


# --- Effect factories ---
func _bleed(stacks: int) -> EffectBleed:
	var e = EffectBleed.new()
	e.stacks = stacks
	return e

func _bleed_self(stacks: int) -> EffectBleed:
	# Used for self-damage cards — applied to self in _apply_card_effects
	# Tag it so CombatManager knows to route it to source not target
	var e = EffectBleed.new()
	e.stacks = stacks
	e.name = "BleedSelf"
	return e

func _regen(stacks: int) -> EffectRegen:
	var e = EffectRegen.new()
	e.stacks = stacks
	return e

func _strength(stacks: int) -> EffectStrength:
	var e = EffectStrength.new()
	e.stacks = stacks
	return e

func _weak(stacks: int) -> EffectWeak:
	var e = EffectWeak.new()
	e.stacks = stacks
	return e

func _vulnerable(stacks: int) -> EffectVulnerable:
	var e = EffectVulnerable.new()
	e.stacks = stacks
	return e

			   
# --- Description generator ---
func _generate_description(damage: int, block: int, draw: int, energy_gain: int, effects: Array) -> String:
	var parts: Array = []
	if damage > 0:
		parts.append("Deal " + str(damage) + " damage")
	if block > 0:
		parts.append("Gain " + str(block) + " block")
	if draw > 0:
		parts.append("Draw " + str(draw))
	if energy_gain > 0:
		parts.append("Gain " + str(energy_gain) + " energy")
	for effect in effects:
		if effect.name == "BleedSelf":
			parts.append("Bleed yourself for " + str(effect.stacks))
		else:
			parts.append("Apply " + str(effect.stacks) + " " + effect.name)
	return ". ".join(parts) + "."
