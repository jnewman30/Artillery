extends Node2D
class_name PlacementComponent

@export var parent: RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_level_started():
	pass


func _on_terrain_generated(points: Array):
	randomize()
	var index = randf_range(0, 1) * (points.size() -1)
	var new_position = points[index]
	parent.position = new_position + Vector2(0, -3)
	parent.freeze = false
