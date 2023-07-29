extends Control
class_name HudComponent

@export var event_manager: EventManagerComponent

signal adjust_power(power: int)
signal adjust_angle(angle: int)
signal adjust_weapon(weapon: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_game_event(event: String, args: Dictionary):
	match event:
		"adjust_angle":
			var angle = args["angle"] as int
			adjust_angle.emit(angle)
		"adjust_power":
			var power = args["power"] as int
			adjust_power.emit(power)
		"adjust_weapon":
			var weapon = args["weapon"] as int
			adjust_weapon.emit(weapon)
		_:
			pass

