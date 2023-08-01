extends Node
class_name PlayerComponent

@export var event_manager: EventManagerComponent

@export var angle: int = 0
@export var power: int = 100
@export var max_power: int = 1000
@export var weapon: int = 0
@export var max_weapon: int = 5

const max_angle: int = 359
var is_human: bool = false
var player_number: int = 0

func _ready():
	event_manager.broadcast_event("adjust_power", { "power": power })
	event_manager.broadcast_event("adjust_angle", { "angle": angle })
	event_manager.broadcast_event("adjust_weapon", { "weapon": weapon })


func _input(event: InputEvent):
	if !is_human: return

	if event.is_action_pressed("Power_Inc", true, true):
		adjust_power(1)
	if event.is_action_pressed("Power_Inc+", true, true):
		adjust_power(10)
	if event.is_action_pressed("Power_Dec", true, true):
		adjust_power(-1)
	if event.is_action_pressed("Power_Dec+", true, true):
		adjust_power(-10)
	if event.is_action_pressed("Angle_Inc", true, true):
		adjust_angle(1)
	if event.is_action_pressed("Angle_Inc+", true, true):
		adjust_angle(10)
	if event.is_action_pressed("Angle_Dec", true, true):
		adjust_angle(-1)
	if event.is_action_pressed("Angle_Dec+", true, true):
		adjust_angle(-10)
	if event.is_action_pressed("Weapon_Inc", false, true):
		adjust_weapon(1)
	if event.is_action_pressed("Weapon_Dec", false, true):
		adjust_weapon(-1)
	if event.is_action_pressed("Fire", false, true):
		event_manager.broadcast_event("fire", {
			"player": player_number,
			"power": power,
			"angle": angle,
			"weapon": weapon
		})
	


func adjust_power(amount: int):
	var last_power = power
	power += amount
	if (power > max_power): power = max_power
	if (power < 0): power = 0
	if last_power == power:
		return
	event_manager.broadcast_event("adjust_power", { "player": player_number, "power": power })


func adjust_angle(deg: int):
	var last_angle = angle
	angle += deg
	if angle > max_angle: angle = max_angle
	if angle < 0: angle = 0
	if last_angle == angle:
		return
	event_manager.broadcast_event("adjust_angle", { "player": player_number, "angle": angle })


func adjust_weapon(inc: int):
	var last_weapon = weapon
	weapon += inc
	if weapon > max_weapon: weapon = max_weapon
	if weapon < 0: weapon = 0
	if last_weapon == weapon:
		return
	event_manager.broadcast_event("adjust_weapon", { "player": player_number, "weapon": weapon })


func _on_game_event(_event: String, _args: Dictionary):
	pass


func _on_tank_tank_spawned(tank: TankComponent):
	is_human = tank.is_human
	player_number = tank.player_number

