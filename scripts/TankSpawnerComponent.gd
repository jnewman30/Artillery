extends Node2D
class_name TankSpawnerComponent

@export var event_manager: EventManagerComponent

var tank_scene = preload("res://scenes/tank.tscn")


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_game_event(event: String, args: Dictionary):
	match event:
		"terrain_generated":
			print_debug("TankSpawner Spawn Tanks")
			var player_positions = args["player_positions"] as Array
			spawn_tanks(player_positions)
		_:
			pass


func spawn_tanks(player_positions: Array):
	var parent = get_parent()
	
	for node in parent.get_children():
		if node is TankComponent:
			parent.remove_child(node)
		
	for p_index in range(0, player_positions.size()):
		var p_pos = player_positions[p_index]
		
		var tank: RigidBody2D = tank_scene.instantiate()
		tank.freeze = true
		tank.position = Vector2(p_pos.x, p_pos.y - 20)
		tank.z_index = 1
		
		if p_index == 0:
			(tank as TankComponent).is_human = true
		
		add_sibling.call_deferred(tank)
		
