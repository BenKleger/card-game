extends Node2D

const NODE_SPACING_X: float = 160.0
const NODE_SPACING_Y: float = 120.0
const NODE_RADIUS: float = 28.0
var floor_map: Dictionary = {}  # floor -> Array[MapNode]
var node_buttons: Array = []
var drag_start: Vector2 = Vector2.ZERO
var is_dragging: bool = false
@onready var camera: Camera2D = $MapCamera
var preview_mode: bool = false
signal close_requested



func _ready() -> void:
	$UI/VBoxContainer/CloseButton.visible = preview_mode
	_build_floor_map()
	_draw_connections()
	_spawn_node_buttons()
	_setup_camera_bounds()
	_focus_camera()

func _focus_camera() -> void:
	# Focus on current node if in a run, otherwise floor 0
	var target_node: MapNode
	if RunState.map_data.current_node_index != -1:
		target_node = RunState.map_data.get_current_node()
	else:
		target_node = RunState.map_data.nodes[0]
	camera.position = _get_node_position(target_node)
	camera.make_current()

func _setup_camera_bounds() -> void:
	# Calculate map extents
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	for node in RunState.map_data.nodes:
		var pos = _get_node_position(node)
		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)
		min_y = min(min_y, pos.y)
		max_y = max(max_y, pos.y)
	
	var padding = 200.0
	var vp = get_viewport_rect().size
	camera.limit_left = int(min_x - padding)
	camera.limit_right = int(max_x + padding)
	camera.limit_top = int(min_y - padding)
	camera.limit_bottom = int(max_y + padding + vp.y * 0.5)	

func _build_floor_map() -> void:
	for node in RunState.map_data.nodes:
		if not floor_map.has(node.current_floor):
			floor_map[node.current_floor] = []
		floor_map[node.current_floor].append(node)

func _setup_camera() -> void:
	camera = Camera2D.new()
	add_child(camera)
	# Start camera showing floor 0 at bottom of screen
	var viewport_height = get_viewport_rect().size.y
	camera.position = Vector2(0, -viewport_height * 0.3)
	camera.make_current()

func _input(event: InputEvent) -> void:
	if camera == null:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_start = event.position
				is_dragging = true
			else:
				is_dragging = false
	if event is InputEventMouseMotion and is_dragging:
		camera.position -= event.relative
		camera.position.x = clamp(camera.position.x, camera.limit_left, camera.limit_right)
		camera.position.y = clamp(camera.position.y, camera.limit_top, camera.limit_bottom)
	# Arrow keys / WASD scroll
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_UP, KEY_W:    camera.position.y -= 40.0
			KEY_DOWN, KEY_S:  camera.position.y += 40.0

func _draw_connections() -> void:
	# Connections drawn via _draw(), flag a redraw
	queue_redraw()

func _draw() -> void:
	var available = RunState.map_data.get_available_nodes()
	var available_indices = available.map(func(n): return n.node_index)
	
	for node in RunState.map_data.nodes:
		var from_pos = _get_node_position(node)
		for conn_idx in node.connections:
			var to_node = RunState.map_data.nodes[conn_idx]
			var to_pos = _get_node_position(to_node)
			var color = Color(0.8, 0.8, 0.8, 0.3)
			# Highlight lines leading to available nodes
			if node.node_index in available_indices or conn_idx in available_indices:
				color = Color(0.9, 0.85, 0.6, 0.7)
			draw_line(from_pos, to_pos, color, 2.0)

func _spawn_node_buttons() -> void:
	var available = RunState.map_data.get_available_nodes()
	var available_indices = available.map(func(n): return n.node_index)
	
	for node in RunState.map_data.nodes:
		var btn = _create_node_button(node, node.node_index in available_indices)
		add_child(btn)
		node_buttons.append(btn)

func _create_node_button(node: MapNode, is_available: bool) -> Button:
	var btn = Button.new()
	btn.text = _get_node_label(node.type)
	btn.size = Vector2(56.0, 56.0)
	var pos = _get_node_position(node)
	btn.position = pos - btn.size / 2.0
	btn.disabled = not is_available
	
	# Visual state
	if node.cleared:
		btn.modulate = Color(0.4, 0.4, 0.4, 1.0)
	elif is_available:
		btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		btn.modulate = Color(0.6, 0.6, 0.6, 0.5)
	
	btn.pressed.connect(_on_node_pressed.bind(node.node_index))
	return btn

func _get_node_position(node: MapNode) -> Vector2:
	var floor_nodes = floor_map[node.current_floor]
	var floor_count = floor_nodes.size()
	var col_index = floor_nodes.find(node)
	
	var viewport_width = get_viewport_rect().size.x
	var x = (col_index - (floor_count - 1) / 2.0) * NODE_SPACING_X + viewport_width / 2.0
	var y = -node.current_floor * NODE_SPACING_Y  # no viewport offset, camera handles that
	return Vector2(x, y)

func _get_node_label(type: GlobalEnums.MapNodeType) -> String:
	match type:
		GlobalEnums.MapNodeType.COMBAT: return "⚔"
		GlobalEnums.MapNodeType.ELITE: return "☠"
		GlobalEnums.MapNodeType.BOSS: return "★"
		GlobalEnums.MapNodeType.SHOP: return "$"
		GlobalEnums.MapNodeType.REST: return "⛺"
		GlobalEnums.MapNodeType.LORE: return "?"
		_: return "?"


func _on_node_pressed(node_index: int) -> void:
	if preview_mode:
		return
	RunState.clear_rewards()
	
	var node = RunState.map_data.nodes[node_index]
	RunState.scene_history.clear()
	RunState.map_data.current_node_index = node_index
	RunState.current_floor = node.current_floor +1
	match node.type:
		GlobalEnums.MapNodeType.COMBAT, GlobalEnums.MapNodeType.ELITE, GlobalEnums.MapNodeType.BOSS:
			RunState.push_scene("res://Scenes/CombatManager.tscn")
		GlobalEnums.MapNodeType.SHOP:
			RunState.push_scene("res://Scenes/Shop.tscn")
		GlobalEnums.MapNodeType.LORE:
			RunState.push_scene("res://Scenes/lore.tscn")
		GlobalEnums.MapNodeType.REST:
			RunState.push_scene("res://Scenes/rest.tscn")
		_:
			push_warning("Node type not yet implemented: " + str(node.type))

func _on_close_pressed() -> void:
	if preview_mode:
		close_requested.emit()
	# if not preview mode, close button does nothing (or hide it entirely)
