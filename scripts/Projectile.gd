extends RigidBody2D

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	pass


func _on_body_shape_entered(body_rid, body: PhysicsBody2D, body_shape_index, local_shape_index):
	var body_groups = body.get_groups()
	
	if body_groups.find("Terrain") >= 0:
		print_debug("Terrain Collision!")
	
	if body_groups.find("Vehichles") >= 0:
		print_debug("Vehichle Collision!")
	
	queue_free()
