class_name Effect
extends Resource
@export var name: String = ""
@export var description: String = ""
@export var stacks: int = 1
@export var proc_on: GlobalEnums.ProcOn
@export var is_debuff: bool = false

func proc(_owner: Node, _from: Node = null) -> void:
	pass

func setup(stacks: int) -> void:
	self.stacks = stacks

func on_applied(_owner: Node) -> void:
	# Called when effect is first applied
	pass

func on_obtained(_owner: Node) -> void:  # NEW
	# Called when obtained via relic/permanent source
	pass

func reduce_stacks(owner: Node, amount: int = 1) -> void:
	stacks -= amount
	if stacks <= 0:
		owner.effects.erase(self)
