---
name: the-scar-remembers
description: >-
  Godot 4 card roguelite architecture, combat systems, summon mechanics, and
  design context for The Scar Remembers. Use when working on card-game code,
  combat, summons, RunState, CardData, encounters, relics, map, rewards, or
  when the user mentions The Scar Remembers, grimdark roguelite, or FIELD cards.
---

# The Scar Remembers

## Quick start

1. Read [reference.md](reference.md) for full project context (architecture, APIs, libraries, TODOs).
2. Check current priorities in `.cursor/rules/scar-remembers.mdc` before starting work.
3. Match existing patterns in `Autoloaded/`, `Scenes/`, and `Resources/` before adding new abstractions.
4. Keep changes scoped to the requested task — call out scope creep if the ask grows.

## Combat work checklist

When touching combat or summons:

- [ ] Enemy targeting follows aggro priority (tank → non-passive → passive → player)
- [ ] Summon death returns source card to discard pile
- [ ] `kill_creature` handles player / enemy / summon paths correctly
- [ ] Effects proc via `_proc_effects(creature, proc_on, from)` at correct phase
- [ ] FIELD cards route through `summon_logic` / `spawn_summon`

## Card colors

| Color  | Role                              |
|--------|-----------------------------------|
| RED    | aggressive, bleed, high damage    |
| BLUE   | defensive, block, regen           |
| GREEN  | draw, energy, tempo               |
| PURPLE | debuffs, vulnerable, disruption   |

## Summon archetypes

- **Tank** (`takes_aggro = true`) — absorbs damage meant for player and other summons
- **Passive/Backline** (`is_passive = true`) — targeted only when no other summons exist or enemy has cleave
- **Aggressive** — attacks enemies each turn when activated

## Additional resources

- Full project context V3: [reference.md](reference.md)
