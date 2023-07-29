extends Node2D
class_name TerrainComponent

@export var event_manager: EventManagerComponent

@export var debug_mode = false
@export var terrain_shape: SS2D_Shape_Base
@export var displacement = 360
@export var iterations = 7
@export var height = 420
@export var smooth: float = 1.0
@export var top_padding = 80
@export var bottom_padding = 20

var points = Array()
var current_displacement
var screen_size: Vector2
var player_positions = Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_game_event(event: String, args: Dictionary):
	match event:
		"level_start":
			screen_size = get_viewport().get_visible_rect().size
			var level = args["level"] as LevelComponent
			generate(level.player_count)
		_:
			pass


func generate(player_count: int):
	generate_player_positions(player_count)
	if debug_mode: debug_player_positions()
	generate_map()
	


func debug_player_positions():
	for child in get_children():
		if child is Line2D:
			remove_child(child)
	
	for p in player_positions:
		var line = Line2D.new()
		line.add_point(Vector2(p.x, 0))
		line.add_point(Vector2(p.x, screen_size.y))
		line.z_index = 2
		line.width = 32;
		line.default_color = Color(0, 1, 0, 0.5)
		add_child(line)
	


func generate_player_positions(player_count: int):
	randomize()
	player_positions.clear()
	var s = screen_size.x / player_count
	for i in range(0, player_count):
		var x = randi_range(0, s) + s * i
		if (x < 64): x += 64
		if (x > screen_size.x - 64): x -= 64
		player_positions.append(Vector2(x, 0))
	


func generate_map():
	var ss2d = self.terrain_shape
	if not ss2d:
		return

	current_displacement = displacement
	
	randomize()
	
	points.clear()
	points.append(Vector2(0, randi_range(height-displacement, height+displacement)))
	points.append(Vector2(screen_size.x, randi_range(height-displacement, height+displacement)))

	terrain_shape.clear_points()
	terrain_shape.begin_update()

	for i in range(0, iterations):
		add_points()

	setup_player_positions()
	
	add_point(0, Vector2(0, screen_size.y + displacement))

	for i in points.size():
		add_point(i + 1, points[i])

	add_point(points.size() + 2, Vector2(screen_size.x, screen_size.y + displacement))
	add_point(points.size() + 3, Vector2(0, screen_size.y + displacement))
	
	terrain_shape.end_update()
	terrain_shape.generate_collision_points()
	terrain_shape.set_as_dirty()
	
	event_manager.broadcast_event("terrain_generated", { "player_positions": player_positions })


func add_point(index: int, point: Vector2) -> void:
	terrain_shape.add_point(point, index, index)


func add_points():
	var old_points = points
	points = Array()
	for i in range(old_points.size() - 1):
		var midpoint = (old_points[i] + old_points[i+1]) / 2
		midpoint.y += current_displacement * pow(-0.5, randi() % 2)
		if midpoint.y >= screen_size.y - bottom_padding:
			midpoint.y = screen_size.y - bottom_padding
		if midpoint.y <= top_padding:
			midpoint.y = top_padding
		points.append(old_points[i])
		points.append(midpoint)
	points.append(old_points[old_points.size() - 1])
	current_displacement *= pow(2.0, -smooth)


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		generate(2)


func setup_player_positions():
	for p_pos in player_positions:
		var t_points = get_terrain_points(p_pos)
		var max_y = 0
		
		for t_pos in t_points:
			max_y = floor(max(max_y, t_pos.y))
		
		for t_pos in t_points:
			var t_index = points.find(t_pos)
			t_pos.y = max_y
			points[t_index] = t_pos
		
		var p_index = player_positions.find(p_pos)
		p_pos.y = max_y
		player_positions[p_index] = p_pos
		

func get_terrain_points(pos: Vector2):
	var min_x = pos.x - 30
	var max_x = pos.x + 30
	return points.filter(func(p: Vector2): return p.x >= min_x and p.x <= max_x)
	


