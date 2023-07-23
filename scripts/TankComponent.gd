extends RigidBody2D
class_name TankComponent

@export var player_number = 1
@export var player_type = 0 ## 0 = sentient, 1 = computer

var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if not started:
		started = true
		await get_tree().create_timer(0.5).timeout
		freeze = false
