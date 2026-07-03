# The Scar Remembers
A Roguelike Card Strategy Game

A modular, data-driven turn-based roguelike built in Godot featuring card-based combat, procedural encounters, persistent progression, and extensible gameplay systems.

## Overview

This project explores the design of scalable gameplay systems through a modular architecture rather than hardcoded mechanics. Cards, enemies, relics, encounters, and status effects are all designed to be easily extended without modifying existing gameplay logic.

The project focuses on creating reusable systems that support rapid content creation while maintaining predictable and deterministic gameplay.

## Core Systems
Data-Driven Action System
Cards execute gameplay through runtime-resolved action sequences rather than hardcoded effects
Actions can target players, enemies, summons, or dynamically generated entities
Supports reusable actions for attacks, healing, buffs, debuffs, spawning, and resource manipulation
Enables rapid creation of new cards without modifying combat logic

## Combat System
Turn-based combat with energy-based card play
Dynamic targeting system
Comprehensive status effect framework
Summon support integrated directly into combat flow
Enemy intent and action sequencing
Four card archetypes (Red, Green, Blue, and Purple), each encouraging different playstyles
Card rarity system (Common, Rare, Legendary) with unique upgrade paths

## Progression Systems
Upgrade cards at rest sites between encounters
Combo-based upgrade system that rewards playing multiple cards of the same color
Cards can gain up to three upgrades through successful combo chains during a run
Persistent relic collection and inventory systems
Shop generation with reroll and purchasing mechanics
Save/load functionality and run state persistence

## Data-Driven Action System
Cards execute gameplay through runtime-resolved action sequences rather than hardcoded effects
Actions can target players, enemies, summons, or dynamically generated entities
Supports reusable actions for attacks, healing, buffs, debuffs, spawning, and resource manipulation
New cards can be created by composing existing actions rather than writing new gameplay code
Card descriptions are generated dynamically from their underlying action definitions, ensuring displayed text always reflects actual gameplay behavior

## Enemy AI
Scriptable enemy behavior using reusable action definitions
Multi-turn behavior patterns
Deterministic decision making
Supports spawning additional enemies and summons

## Procedural Encounter Generation
Randomized encounter generation
Weighted encounter pools
Event, combat, elite combat, and shop nodes
Extensible encounter definitions

## Inventory & Progression
Persistent inventory system: deck and relics
Shop with purchasing mechanics
Relic collection system
Save/load functionality
Run state management
## UI Architecture
Modular UI built using reusable Godot scenes
Dynamic card generation
Reusable combat interface components
Data-driven UI updates tied directly to game state
Technical Design

Rather than implementing each card or enemy individually, the project emphasizes reusable gameplay systems that can be composed together.

Examples include:

Runtime action resolution
Resource-based gameplay definitions
Modular status effect handling
Shared action execution pipeline
Reusable encounter framework


## Design Goals
Data-driven gameplay
Modular architecture
Extensible content creation
Minimal hardcoded logic
Reusable gameplay systems
Deterministic combat resolution

## Tech Stack
Godot Engine
GDScript


## Screenshots
#TODO
#combat|hand of cards|shop|relic screen|encounter map|status effects|summon(s)


## Running the Project (Windows only)
1. Click the green 'Code' button
2. Download the project as a zip
3. Run the 'Card Game.exe' file.
