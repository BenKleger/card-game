# The Scar Remembers - A Roguelike Card Strategy Game

A modular, data-driven turn-based roguelike built in Godot featuring card-based combat, procedural encounters, persistent progression, and extensible gameplay systems.

Gameplay content is authored through reusable resources and composable action definitions, allowing new cards, enemies, relics, and encounters to be created with minimal additional code.

---

## Overview

This project explores the design of scalable gameplay systems through a modular architecture rather than hardcoded mechanics. Cards, enemies, relics, encounters, and status effects are all designed to be easily extended without modifying existing gameplay logic.

The project emphasizes reusable gameplay systems that enable rapid content creation while maintaining deterministic combat behavior.

---

# Core Systems

## Data-Driven Action System

- Cards execute gameplay through runtime-resolved action sequences rather than hardcoded effects
- Actions can target players, enemies, summons, or dynamically generated entities
- Supports reusable actions for attacks, healing, buffs, debuffs, spawning, and resource manipulation
- New cards are authored by composing existing actions rather than writing bespoke gameplay code
- Card descriptions are generated automatically from their underlying action definitions, ensuring displayed text always reflects gameplay behavior

---

## Combat System

- Turn-based combat with energy-based card play
- Dynamic targeting system
- Comprehensive status effect framework
- Summon support integrated directly into combat flow
- Enemy intent and action sequencing
- Four card archetypes (Red, Green, Blue, and Purple), each supporting distinct playstyles
- Three rarity tiers (Common, Rare, Legendary), each visually distinguished with unique upgrade paths

---

## Progression Systems

- Upgrade cards at rest sites between encounters
- Combo-based upgrade system that rewards consecutive plays of the same card color
- Cards can receive up to three upgrades through combo progression during a run
- Persistent relic collection and inventory systems
- Shop generation with reroll and purchasing mechanics
- Save/load functionality and run state persistence

---

## Enemy AI

- Scriptable enemy behavior using reusable action definitions
- Multi-turn behavior patterns
- Deterministic decision making
- Supports spawning additional enemies and summons

---

## Procedural Encounter Generation

- Randomized encounter generation
- Weighted encounter pools
- Event, combat, elite combat, and shop nodes
- Extensible encounter definitions

---

## Inventory Systems

- Persistent deck and relic management
- Shop with purchasing mechanics
- Save/load functionality
- Run state management

---

## UI Architecture

- Modular UI built using reusable Godot scenes
- Dynamic card generation
- Reusable combat interface components
- Data-driven UI updates tied directly to game state

---

## Technical Design

Rather than implementing each card or enemy individually, the project emphasizes reusable gameplay systems that can be composed together.

Examples include:

- Runtime action resolution
- Resource-driven gameplay definitions
- Modular status effect handling
- Shared action execution pipeline
- Reusable encounter framework
- Dynamic card description generation
- Extensible relic and upgrade systems

---

## Design Goals

- Data-driven gameplay
- Modular architecture
- Extensible content creation
- Minimal hardcoded logic
- Reusable gameplay systems
- Deterministic combat resolution

---

## Tech Stack

- Godot Engine
- GDScript

---

## Screenshots

> TODO

- Combat
- Hand of cards
- Shop
- Relic screen
- Encounter map
- Status effects
- Summons

---

## Running the Project (Windows)

1. Click the green **Code** button.
2. Select **Download ZIP**.
3. Extract the archive.
4. Run **Card Game.exe**.
