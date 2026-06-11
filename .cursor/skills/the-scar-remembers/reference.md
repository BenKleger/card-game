# The Scar Remembers — Project Context V3

## Overview

Dark grimdark card roguelite, STS-inspired but differentiated. Working title: **The Scar Remembers**.

**Engine:** Godot 4 + GDScript  
**Goal:** Vertical slice on itch.io  
**Convention:** Tabs for indentation, PascalCase for scenes, camelCase for variables

---

## Team

- **Ben** — programming, CompEng, UBCO
- **Zac** (brother) — writing, world/lore (PENDING: faction names + identities)
- **Cole** — grimdark art (not yet confirmed)
- **Tony** — sound design (when ready)

## Personality / Accountability

- Strong ideator, struggles with initiation and follow-through
- Scope creep tendency — call it out firmly
- Does not want validation, wants direct honest feedback
- Working with counsellor Graeme, meditation, sobriety work

---

## Core Design

### Differentiators from STS

- **Summon/Field card system** — cards spawn persistent creatures with HP pools
- Time rewind mechanic (NOT YET BUILT)
- Boss mutates on rewind
- Color synergy tied to factions (BLOCKED on Zac)
- Mid-combat card shop (not yet built)

### Card Colors

- RED — aggressive, bleed, high damage
- BLUE — defensive, block, regen
- GREEN — draw, energy, tempo
- PURPLE — debuffs, vulnerable, disruption

### Summon Archetypes

- **Tank** (`takes_aggro = true`) — absorbs damage meant for player and other summons
- **Passive/Backline** (`is_passive = true`) — only targeted when no other summons exist or enemy has cleave
- **Aggressive** — attacks enemies each turn when activated

### Summon Rules (decided)

- Each card can only spawn one summon instance at a time
- Card returns to discard pile when summon dies
- Click summon to activate its action (separate from card selection flow)
- Used summons grey out, reset at turn start
- Summons have own HP pool (`summon_hp` on CardData)
- `summon_damage` field for auto-attack value

### Summon Rules (TODO)

- Sacrifice mechanic for certain summons
- Cards that can target summons as well as self
- Multi-target conditions (SELF + SUMMONS)

---

## TODAY'S PLAN

### Priority Order

1. **Enemy targeting priority** — enemies attack summons before player based on aggro rules
2. **Summon layout** — 3 columns by aggro level (Tank | Aggressive | Passive), max capacity per column
3. **Summon death → card return** — when summon dies, card goes back to discard
4. **Card targeting summons** — SELF cards optionally target summons too
5. **Combat manager integration** — summons tick effects, bleed, regen each turn

---

## Architecture

### Autoload Order

1. `GlobalConstants`
2. `GlobalEnums`
3. `RunState`
4. `CardLibrary`
5. `EncounterLibrary`
6. `RelicLibrary`

### GlobalEnums

```gdscript
enum ProcOn { TURN_START, TURN_END, ON_SHIELD_DAMAGED, ON_HP_DAMAGED, ON_CARD_PLAYED, ON_ATTACK, START_COMBAT }
enum CardType { TEMPORARY, PERMANENT, FIELD }
enum CardColor { RED, BLUE, GREEN, PURPLE }
enum IntentType { ATTACK, BLOCK, DEBUFF, BUFF, SUMMON }
enum MapNodeType { SHOP, COMBAT, ELITE, BOSS, LORE, REST }
enum CardRarity { COMMON, RARE, LEGENDARY }
```

---

## RunState

```gdscript
extends Node
var scene_history: Array[String] = []
var map_data: MapData = null
var deck: Array[CardData] = []
var gold: int
var current_hp: int
var max_hp: int
var max_hand_size: int
var max_energy: int
var block_clear: bool
var card_choices: int
var card_draw: int
var current_floor: int = 0
var relics: Array = []
var rng := RandomNumberGenerator.new()
var top_bar: CanvasLayer = null
var deck_viewer: CanvasLayer = null

# Offerings
var gold_offered: int = 0
var gold_accepted: bool = false
var cards_offered: Array[CardData] = []
var cards_generated: bool = false
var relics_offered: Array[RelicData] = []
var relic_accepted: bool = false

# Relic stat modifiers
var card_energy_reduction: int = 0
var damage_reduction: int = 0
var enemy_bleed_reduction: int = 0
var block_pierce: int = 0
var gold_per_kill: int = 0
var look_ahead_turns: int = 1
var enemy_miss_chance: float = 0.0
var rewind_available: bool = false
var death_save_available: bool = false
var feast_threshold: int = 0
var weak_on_play: bool = false

# Scene management
func push_scene(path: String) -> void
func pop_scene() -> void
func current_scene_path() -> String
func new_run(run_seed: int = randi()) -> void  # clears history, resets all
func clear_rewards() -> void
func open_deck_viewer(parent: Node, cards: Array[CardData], title: String) -> void

# _ready() spawns TopBar and EscapeMenu via call_deferred
```

### Scene History Rules

- Write on entering: combat, map, reward, shop, rest, lore
- Don't write on: main menu, lose screen
- Clear on: new node press, reward confirmed, loss, new_run()
- Continue button reads current_scene_path()

---

## Resources

### CardData

```gdscript
@export var card_name: String
@export var description: String
@export var rarity: GlobalEnums.CardRarity
@export var color: GlobalEnums.CardColor
@export var card_type: GlobalEnums.CardType
@export var in_field: bool = false
@export var used_this_turn: bool = false
@export var art: Texture2D
@export var uid: int = 0
@export var damage: int
@export var block: int
@export var effects: Array[Effect]
@export var draw: int
@export var energy_cost: int
@export var energy_gain: int
@export var coin_value: int
@export var coin_gain: int
# Summon fields
@export var summon_hp: int = 0
@export var takes_aggro: bool = false
@export var is_passive: bool = false
@export var summon_damage: int = 0
# Upgrade fields
@export var damage_upgrade: int
@export var block_upgrade: int
@export var effects_upgrade: Array[Effect]
@export var draw_upgrade: int
@export var energy_cost_upgrade: int
@export var energy_gain_upgrade: int
@export var max_upgrades: int = 1
var upgrade_level: int = 0
func upgrade() -> void
func can_upgrade() -> bool
func get_energy_cost() -> int
func get_damage() -> int
func get_block() -> int
enum TargetType { NONE, SINGLE_ENEMY, ALL_ENEMIES, SELF }
@export var target_type: TargetType
```

### Effect (base)

```gdscript
@export var name: String
@export var description: String
@export var stacks: int = 1
@export var proc_on: GlobalEnums.ProcOn
@export var is_debuff: bool = false
func proc(owner: Node, from: Node = null) -> void
func on_applied(owner: Node) -> void
func on_obtained(owner: Node) -> void
func reduce_stacks(owner: Node, amount: int = 1) -> void
```

### Concrete Effects

- `EffectBleed` — TURN_START, deals stacks damage, reduces stacks
- `EffectRegen` — TURN_START, heals stacks hp, reduces stacks
- `EffectStrength` — checked in _attack_target (flat damage bonus)
- `EffectWeak` — checked in _attack_target (25% less damage)
- `EffectVulnerable` — TURN_END reduces stacks, checked in _attack_target (50% more damage taken)

### EnemyData

```gdscript
@export var enemy_name: String
@export var base_hp: int
@export var gold_drop: int = 0
@export var actions_per_turn: int = 1
@export var starting_moves: Array[EnemyMove]
@export var move_pool_loop: Array[EnemyMove]
@export var art: Texture2D
```

### EnemyMove

```gdscript
@export var intent_type: GlobalEnums.IntentType
@export var value: int
@export var has_secondary: bool = false
@export var secondary_intent_type: GlobalEnums.IntentType
@export var secondary_value: int
@export var description: String
@export var effects_on_target: Array[Effect]
@export var effects_on_self: Array[Effect]
@export var icon: Texture2D
# TODO: attack variant flags
# ignore_aggro: bool — bypasses tank summons
# cleave_backline: bool — hits passive summons
# target_summons_only: bool
```

### SummonCreature (Control) — NEW

```gdscript
class_name SummonCreature
extends Control
var card_data: CardData
var current_hp: int
var max_hp: int
var block: int = 0
var effects: Array[Effect] = []
var takes_aggro: bool = false
var is_passive: bool = false
var uid: int = 0
signal clicked(summon: SummonCreature)
func setup(data: CardData) -> void
func update_stats() -> void
func _gui_input(event) -> void  # emits clicked
```

### EnemyCreature (Control)

```gdscript
@export var data: EnemyData
var current_hp: int
var max_hp: int
var block: int = 0
var effects: Array[Effect]
var uid: int = 0
signal clicked(enemy: EnemyCreature)
func display_move(move: EnemyMove) -> void
func update_stats() -> void
```

---

## CombatManager

### Key Variables

```gdscript
var enemies: Array[EnemyCreature]
var summons: Array[SummonCreature]  # NEW
var phase: Phase
var turn_number: int
var selected_card: CardData
var hand_size_modifier: int
var card_draw_modifier: int
```

### Phase Flow

```
PLAYER_TURN_START → PLAYER_TURN → PLAYER_TURN_END → enemy sequence → PLAYER_TURN_START
END_COMBAT → victory or loss
```

### Key Functions

- `advance_phase()` — state machine driver
- `_do_player_turn_start()` — clear block, proc TURN_START, check death, draw, restore energy, reset summon used_this_turn
- `_do_player_turn_end()` — proc TURN_END, discard hand
- `_do_enemy_turn_start()` — clear enemy block, proc START, check death
- `_do_enemy_turn()` — pick + execute moves, display next intent
- `_do_enemy_turn_end()` — proc enemy TURN_END
- `apply_effect(effect, target)` — stacks if same script, else duplicate + append
- `_proc_effects(creature, proc_on, from)` — fires matching effects
- `_attack_target(damage, target, source)` — Strength → Weak → Vulnerable → damage
- `check_death(creature)` — calls kill_creature if hp <= 0
- `kill_creature(creature)` — player→END_COMBAT, enemy→erase+check empty, summon→erase+return card to discard (TODO)
- `_end_combat_victory()` — call_deferred push RewardManager
- `_end_combat_loss()` — call_deferred change to lose scene

### Summon Flow (current)

```gdscript
# select_target routes to summon_logic if card_type == FIELD
func summon_logic(target) -> void  # spawning only now
func spawn_summon(card_data) -> void  # creates SummonCreature, adds to summons array
func _on_summon_clicked(summon: SummonCreature) -> void  # activates summon action
func _execute_summon_action(summon: SummonCreature) -> void  # does damage/effects
```

### Enemy Targeting (TODO — priority 1 today)

Current: always targets player  
Needed priority:

1. `takes_aggro` summons first
2. Non-passive summons second
3. Passive summons third
4. Player last

### Combat Scene Tree

```
CombatManager
├── DeckManager
└── UI
    └── UIHeirarchy
        ├── TopBarNode (OLD — delete)
        ├── BattleAreaNode
        │   └── BattleArea (HBoxContainer)
        │       ├── PlayerArea
        │       │   ├── PlayerCreature
        │       │   └── SummonContainer  ← summons spawn here
        │       └── EnemyArea
        └── BottomBarNode
            └── BottomBar
                ├── DrawButton
                ├── HandContainer
                ├── DiscardButton
                ├── EnergyLabel
                └── EndTurnButton
```

---

## Card Library Summary

**Normal cards:** Strike, Defend, Cleave, Hemorrhage, Reckless Strike, Gore, Bloodlust, Carve, Sever, Brace, Mend, Iron Skin, Parry, Bulwark, Counter, Aegis, Surge, Scratch, Rummage, Adrenaline, Windfall, Cascade, Enfeeble, Expose, Unnerve, Rot, Shatter, Plague, Unravel

**Field/Summon cards (40 total):**

- RED aggressive: Rabid Hound, Flagellant, Bone Archer, Plague Bearer, Marrow Thresher, Gore Hound Pack, The Unforgiven, Revenant Blade, Ashen Berserker, The Devourer
- BLUE defensive: Shield Warden, Bone Wall, Sutured Guard, Ash Sentinel, Hollow Knight, Iron Penitent, The Unbroken, Grave Bulwark, The Last Rampart, Deathless Warden
- GREEN utility: Crow Scout, Scrap Hoarder, Ash Wanderer, Remnant Tinkerer, Void Siphon, Ruin Salvager, Bone Harvester, The Chronicler, Eternal Scavenger, The Archivist
- PURPLE cursed: Festering Thrall, Hollow Vessel, Spite Engine, Rotting Prophet, Plague Engine, Desecrator, The Withered, Abyssal Anchor, The Unraveling, Void Incarnate

**Note:** Field cards need `summon_hp`, `takes_aggro`, `is_passive`, `summon_damage` values set per card — currently using CardData defaults (0/false/false/0)

---

## Encounter Library

**Combat:** Ashwalker Scout, Rot Hound, Scavenger Pair, Hollow Penitent, Ashwalker+Hound  
**Elite:** Flayed Warden, The Twice-Hanged  
**Boss:** The Sutured King

---

## Relic Library (20 relics)

Common: Cracked Fang, Soiled Bandage, Bottled Spite, Rust-Eaten Locket, Vial of Ash, Scar Tissue  
Rare: Sutured Heart, Prisoner's Chain, Plague Mask, Hollow Bone, Corpse-Eater's Tooth, Thorn Wrapping, Obsidian Eye, Widow's Silk  
Legendary: The Scarred Crown, Chronometer Heart, Deathless Covenant, Feast of Crows, Unraveling Bind, The Stitch

---

## Scenes

- `main_menu.tscn` — New Game, Continue, Quit
- `CombatManager.tscn`
- `MapManager.tscn` — preview_mode support, signal close_requested
- `RewardManager.tscn`
- `DeckViewer.tscn` — CanvasLayer, init(cards, title) BEFORE add_child
- `TopBar.tscn` — CanvasLayer, spawned in RunState._ready() via call_deferred
- `EscapeMenu.tscn` — CanvasLayer, spawned in RunState._ready() via call_deferred
- `SummonCreature.tscn` — NEW, similar structure to EnemyCreature
- `lose.tscn`
- `Shop.tscn` — placeholder
- `rest.tscn` — placeholder
- `lore.tscn` — placeholder

---

## Map

- 10 floors, floor 0 = single combat, floor 9 = boss
- No-crossing connection algorithm
- Camera2D with drag/WASD scroll, bounds clamped
- Focuses on current node on load
- preview_mode blocks node pressing, shows close button

---

## Reward Flow

- Gold: base (30+5*floor combat, 100+10*floor elite, 250+20*floor boss) + enemy gold_drop
- Cards: weighted by rarity + room type, 3 choices default
- Relics: 1 per reward, weighted by room type
- clear_rewards() called when pressing new map node

---

## Known TODOs

- **Enemy targeting priority** — TODAY #1
- **Summon layout 3 columns** — TODAY #2 (Tank|Aggressive|Passive)
- **Summon death → card to discard** — TODAY #3
- **Cards targeting summons** — TODAY #4
- **Summon effects ticking** — TODAY #5
- **Rewind mechanic** — THE differentiator, not started
- **Color synergy** — blocked on Zac's faction answers
- **Mid-combat shop** — placeholder
- **Field/Temporary card type enforcement** — FIELD done, TEMPORARY not enforced
- **Rest site upgrade mechanic** — DeckViewer upgrade_mode
- **current_floor increment** — never increments
- **Boss mutation on rewind**
- **Animations everywhere**
- **Confirm end turn popup**
- **Font scaling**

---

## Backburner (do not touch)

YouTime app, IWantThat, snowboard sensors, Warhammer layer, thread counter, gifting platform
