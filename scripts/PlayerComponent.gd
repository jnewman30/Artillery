extends Node
class_name PlayerComponent

@onready var ball = preload("res://scenes/projectile.tscn")

@export var event_manager: EventManagerComponent
@export var fire_line: Line2D
@export var angle: int = 0
@export var power: int = 100
@export var max_power: int = 1000
@export var weapon: int = 0
@export var max_weapon: int = 5
@export var fast_mode = 5
@export var fire_line_length = 10

const max_angle: int = 359
var is_human: bool = false
var player_number: int = 0
var fire_dir = Vector2(0, -1).rotated(deg_to_rad(angle))

func _ready():
	event_manager.broadcast_event("adjust_power", { "power": power })
	event_manager.broadcast_event("adjust_angle", { "angle": angle })
	event_manager.broadcast_event("adjust_weapon", { "weapon": weapon })

func _physics_process(delta):
	if !is_human: return

	var inc_angle = Input.is_action_pressed("Angle_Inc")
	var dec_angle = Input.is_action_pressed("Angle_Dec")
	var inc_power = Input.is_action_pressed("Power_Inc")
	var dec_power = Input.is_action_pressed("Power_Dec")
	var aim_mod = Input.is_action_pressed("Aim_Mod")

	if inc_angle and !aim_mod:
		adjust_angle(1)
		recalc_fire_dir()
	if inc_angle and aim_mod:
		adjust_angle(fast_mode)
		recalc_fire_dir()

	if dec_angle and !aim_mod:
		adjust_angle(-1)
		recalc_fire_dir()
	if dec_angle and aim_mod:
		adjust_angle(-fast_mode)
		recalc_fire_dir()
	
	if inc_power and !aim_mod:
		adjust_power(1)
	if inc_power and aim_mod:
		adjust_power(fast_mode)
	
	if dec_power and !aim_mod:
		adjust_power(-1)
	if dec_power and aim_mod:
		adjust_power(-fast_mode)


func _input(event: InputEvent):
	if !is_human: return
	if event.is_action_pressed("Fire", false, true):
		fire_projectile()


func adjust_power(amount: int):
	var last_power = power
	power += amount
	if (power > max_power): power = max_power
	if (power < 0): power = 0
	if last_power == power:
		return
	event_manager.broadcast_event("adjust_power", { "player": player_number, "power": power })


func adjust_angle(deg: int):
#	var last_angle = angle
	angle += deg
#	if angle > max_angle: angle = max_angle
#	if angle < 0: angle = 0
#	if last_angle == angle:
#		return
	event_manager.broadcast_event("adjust_angle", { "player": player_number, "angle": angle })


func adjust_weapon(inc: int):
	var last_weapon = weapon
	weapon += inc
	if weapon > max_weapon: weapon = max_weapon
	if weapon < 0: weapon = 0
	if last_weapon == weapon:
		return
	event_manager.broadcast_event("adjust_weapon", { "player": player_number, "weapon": weapon })


func recalc_fire_dir():
	var rot = deg_to_rad(angle)
	fire_dir = Vector2(0, -1).rotated(rot)
	fire_line.points[1] = fire_dir * fire_line_length


func fire_projectile():
	var projectile = ball.instantiate() as RigidBody2D
	var spawn_pos: Vector2 = fire_line.points[1] + get_parent().global_position
	projectile.position = spawn_pos
	get_tree().root.add_child(projectile);
	projectile.apply_impulse(fire_dir * (power * 2))


func _on_game_event(_event: String, _args: Dictionary):
	pass


func _on_tank_tank_spawned(tank: TankComponent):
	is_human = tank.is_human
	player_number = tank.player_number

