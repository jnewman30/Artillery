extends Node2D
class_name LevelComponent

@export var player_count = 2

signal on_game_event(event: String, args: Dictionary)


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	broadcast_event("level_start", { "level": self })
	get_viewport().connect("size_changed", _on_viewport_resize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func register_for_events(callable: Callable):
	if !on_game_event.is_connected(callable):
		on_game_event.connect(callable)


func broadcast_event(event: String, args: Dictionary):
	on_game_event.emit(event, args)


func _on_viewport_resize():
	broadcast_event("viewport_resize", {})
