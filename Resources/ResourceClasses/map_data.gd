class_name MapData
extends Resource

@export var nodes: Array[MapNode]
@export var current_node_index: int = -1
@export var node_lookup: Dictionary  # Vector2i -> MapNode




func get_current_node() -> MapNode:
	if current_node_index == -1:
		return null
	return nodes[current_node_index]
	
func get_available_nodes() -> Array[MapNode]:
	# nodes reachable from current position
	if current_node_index == -1:
		return _get_starting_nodes()  # floor 0 nodes
	var current = get_current_node()
	var result: Array[MapNode] = []
	for idx in current.connections:
		if not nodes[idx].cleared:
			result.append(nodes[idx])
	return result

func _get_starting_nodes() -> Array[MapNode]:
	# Returns all nodes on floor 0 — entry points to the map
	var result: Array[MapNode] = []
	for node in nodes:
		if node.floor == 0:
			result.append(node)
	return result
	
func generate(rng: RandomNumberGenerator) -> void:
	nodes.clear()
	current_node_index = -1
	
	# Config
	var floors: int = 10
	var max_paths: int = 3
	var min_nodes_per_floor: int = 2
	var max_nodes_per_floor: int = 4
	
	var type_weights: Dictionary = {
		GlobalEnums.MapNodeType.COMBAT: 50,
		GlobalEnums.MapNodeType.ELITE: 15,
		GlobalEnums.MapNodeType.SHOP: 15,
		GlobalEnums.MapNodeType.REST: 10,
		GlobalEnums.MapNodeType.LORE: 10,
	}
	
	# --- Build nodes floor by floor ---
	var floor_nodes: Array[Array] = []
	for f in floors:
		var count: int
		if f == 0 or f == floors - 1:
			count = 1
		else:
			count = rng.randi_range(min_nodes_per_floor, max_nodes_per_floor)
		var this_floor: Array = []
		for i in count:
			var node = MapNode.new()
			node.floor = f
			node.node_index = nodes.size()
			node.type = _pick_node_type(f, floors, type_weights, rng)
			node.encounter = _pick_encounter(node.type, rng)
			nodes.append(node)
			this_floor.append(node.node_index)
		floor_nodes.append(this_floor)
	
	# --- Connect floors without crossing lines ---
	# Key insight: sort both floors by column index (they already are, since we
	# append left to right). A connection from from_col to to_col is valid only
	# if it doesn't cross any existing connection. Two connections cross if:
	# (a_from < b_from and a_to > b_to) or (a_from > b_from and a_to < b_to)
	# So we track connections as (from_col, to_col) pairs and reject crossings.
	
	for f in floors - 1:
		var from_indices = floor_nodes[f]
		var to_indices = floor_nodes[f + 1]
		var from_count = from_indices.size()
		var to_count = to_indices.size()
		
		# Track connections as column pairs to check crossings
		var connections_made: Array = []  # Array of [from_col, to_col]
		
		# Step 1 — guarantee every from-node has at least one connection
		# Walk from-nodes left to right, assign a valid non-crossing target
		for fi in from_count:
			var from_node = nodes[from_indices[fi]]
			
			# Find valid to_cols — must not cross existing connections
			var valid_to_cols: Array = []
			for ti in to_count:
				if _is_valid_connection(fi, ti, connections_made):
					valid_to_cols.append(ti)
			
			if valid_to_cols.is_empty():
				# Fallback — take closest available
				valid_to_cols = [_closest_col(fi, from_count, to_count)]
			
			# Pick one randomly from valid options
			var chosen_ti = valid_to_cols[rng.randi_range(0, valid_to_cols.size() - 1)]
			from_node.connections.append(to_indices[chosen_ti])
			connections_made.append([fi, chosen_ti])
		
		# Step 2 — guarantee every to-node has at least one incoming connection
		for ti in to_count:
			var has_incoming = false
			for fi in from_count:
				if to_indices[ti] in nodes[from_indices[fi]].connections:
					has_incoming = true
					break
			if not has_incoming:
				# Find a from-node that can connect without crossing
				var valid_from_cols: Array = []
				for fi in from_count:
					if _is_valid_connection(fi, ti, connections_made):
						valid_from_cols.append(fi)
				var chosen_fi: int
				if valid_from_cols.is_empty():
					chosen_fi = _closest_col(ti, to_count, from_count)
				else:
					chosen_fi = valid_from_cols[rng.randi_range(0, valid_from_cols.size() - 1)]
				nodes[from_indices[chosen_fi]].connections.append(to_indices[ti])
				connections_made.append([chosen_fi, ti])
		
		# Step 3 — add extra connections up to max_paths, no crossings
		for fi in from_count:
			var from_node = nodes[from_indices[fi]]
			var current_count = from_node.connections.size()
			if current_count >= max_paths:
				continue
			var extras = rng.randi_range(0, max_paths - current_count)
			for _e in extras:
				var valid_to_cols: Array = []
				for ti in to_count:
					if to_indices[ti] not in from_node.connections:
						if _is_valid_connection(fi, ti, connections_made):
							valid_to_cols.append(ti)
				if valid_to_cols.is_empty():
					break
				var chosen_ti = valid_to_cols[rng.randi_range(0, valid_to_cols.size() - 1)]
				from_node.connections.append(to_indices[chosen_ti])
				connections_made.append([fi, chosen_ti])


func _is_valid_connection(from_col: int, to_col: int, existing: Array) -> bool:
	# A new connection (from_col -> to_col) is invalid if it crosses any existing one
	for conn in existing:
		var ef = conn[0]
		var et = conn[1]
		# Crossing condition: one goes left-to-right while the other goes right-to-left
		if (ef < from_col and et > to_col) or (ef > from_col and et < to_col):
			return false
	return true


func _closest_col(col: int, col_count: int, target_count: int) -> int:
	# Map col proportionally to target floor's column range
	return int(round(float(col) / max(col_count - 1, 1) * max(target_count - 1, 1)))
	
func _pick_encounter(type: GlobalEnums.MapNodeType, rng: RandomNumberGenerator) -> EncounterData:
	return EncounterLibrary.get_encounters_for_type(type, rng)

func _pick_node_type(
	floor: int,
	total_floors: int,
	weights: Dictionary,
	rng: RandomNumberGenerator
) -> GlobalEnums.MapNodeType:
	if floor == 0:
		return GlobalEnums.MapNodeType.COMBAT
	if floor == total_floors - 1:
		return GlobalEnums.MapNodeType.BOSS
	# No elites on floor 1, no shops on floor 1
	var adjusted = weights.duplicate()
	if floor <= 1:
		adjusted[GlobalEnums.MapNodeType.ELITE] = 0
		adjusted[GlobalEnums.MapNodeType.SHOP] = 0
		adjusted[GlobalEnums.MapNodeType.LORE] = 0
	
	var total = 0
	for w in adjusted.values():
		total += w
	var roll = rng.randi_range(0, total - 1)
	var cumulative = 0
	for type in adjusted:
		cumulative += adjusted[type]
		if roll < cumulative:
			return type
	return GlobalEnums.MapNodeType.COMBAT
