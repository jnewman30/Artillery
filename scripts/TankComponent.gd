extends RigidBody2D
class_name TankComponent

signal tank_spawned(is_human: bool)

@export var is_human = false

var started = false


# Called when the node enters the scene tree for the first time.
func _ready():
	tank_spawned.emit(is_human)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(_delta):
	if not started:
		started = true
		await get_tree().create_timer(0.5).timeout
		freeze = false
