extends Node2D
class_name TerrainComponent

@export var terrain_shape: SS2D_Shape_Base
@export var displacement = 360
@export var iterations = 7
@export var height = 420
@export var smooth: float = 1.0
@export var top_padding = 80
@export var bottom_padding = 20


var points = Array()
var current_displacement


signal terrain_generated(points: Array)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func generate():
	var ss2d = self.terrain_shape
	if not ss2d:
		return

	current_displacement = displacement
	
	var screenSize = get_viewport().get_visible_rect().size
	randomize()
	
	points.clear()
	points.append(Vector2(0, randi_range(height-displacement, height+displacement)))
	points.append(Vector2(screenSize.x, randi_range(height-displacement, height+displacement)))

	terrain_shape.clear_points()
	terrain_shape.begin_update()

	for i in range(0, iterations):
		add_points()

	add_point(0, Vector2(0, screenSize.y + displacement))

	for i in points.size():
		add_point(i + 1, points[i])

	add_point(points.size() + 2, Vector2(screenSize.x, screenSize.y + displacement))
	add_point(points.size() + 3, Vector2(0, screenSize.y + displacement))
	
	terrain_shape.end_update()
	terrain_shape.generate_collision_points()
	terrain_shape.set_as_dirty()
	
	terrain_generated.emit(points)


func add_point(index: int, point: Vector2) -> void:
	terrain_shape.add_point(point, index, index)


func add_points():
	var screenSize = get_viewport().get_visible_rect().size
	var old_points = points
	points = Array()
	for i in range(old_points.size() - 1):
		var midpoint = (old_points[i] + old_points[i+1]) / 2
		midpoint.y += current_displacement * pow(-0.5, randi() % 2)
		if midpoint.y >= screenSize.y - bottom_padding:
			midpoint.y = screenSize.y - bottom_padding
		if midpoint.y <= top_padding:
			midpoint.y = top_padding
		points.append(old_points[i])
		points.append(midpoint)
	points.append(old_points[old_points.size() - 1])
	current_displacement *= pow(2.0, -smooth)


#func _input(event):
#	if event is InputEventMouseButton and event.is_pressed():
#		generate()


func _on_level_started():
	generate()
