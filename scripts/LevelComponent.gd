extends Node2D
class_name LevelComponent

@export var player_count = 2

signal Level_Started(player_count: int)


# Called when the node enters the scene tree for the first time.
func _ready():
	Level_Started.emit(player_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
