extends Node
class_name EventManagerComponent

signal on_game_event(event: String, args: Dictionary)


# Called when the node enters the scene tree for the first time.
func _ready():
	var level = get_level()
	if level: level.register_for_events(_on_game_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func broadcast_event(event: String, args: Dictionary):
	var level = get_level()
	if level: level.broadcast_event(event, args)


func get_level() -> LevelComponent:
	var results = get_tree().get_nodes_in_group("Level")
	if results.size() > 0: return results[0]
	return null


func _on_game_event(event: String, args: Dictionary):
	on_game_event.emit(event, args)

