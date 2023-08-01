extends RigidBody2D
class_name TankComponent

signal tank_spawned(tank: TankComponent)

@export var is_human = false
@export var player_number = 0

var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	tank_spawned.emit(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(_delta):
	if not started:
		started = true
		await get_tree().create_timer(0.25).timeout
		freeze = false


func _on_event_manager_component_on_game_event(event: String, args: Dictionary):
	print_debug(event, " ", args)
	if args.find_key("player"):
		var player = int(args["player"])
		if player != player_number: return

		match event:
			"fire":
				print_debug("Tank ", event, args)
			_:
				pass
