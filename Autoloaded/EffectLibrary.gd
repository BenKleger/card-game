#EffectLibrary
extends Node
# Factories — always return fresh instances
func bleed(stacks: int) -> EffectBleed:
	return _make(EffectBleed.new(), stacks)

func regen(stacks: int) -> EffectRegen:
	return _make(EffectRegen.new(), stacks)

func strength(stacks: int) -> EffectStrength:
	return _make(EffectStrength.new(), stacks)

func weak(stacks: int) -> EffectWeak:
	return _make(EffectWeak.new(), stacks)

func vulnerable(stacks: int) -> EffectVulnerable:
	return _make(EffectVulnerable.new(), stacks)

func thorns(stacks: int) -> EffectThorns:
	return _make(EffectThorns.new(), stacks)

func burn(stacks: int) -> EffectBurn:
	return _make(EffectBurn.new(), stacks)

func frail(stacks: int) -> EffectFrail:
	return _make(EffectFrail.new(), stacks)

func poison(stacks: int) -> EffectPoison:
	return _make(EffectPoison.new(), stacks)

func barrier(stacks: int) -> EffectBarrier:
	return _make(EffectBarrier.new(), stacks)

func _make(effect: Effect, stacks: int) -> Effect:
	effect.setup(stacks)
	return effect
