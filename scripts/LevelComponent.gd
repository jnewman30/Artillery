extends Node2D
class_name LevelComponent

signal Level_Started()

# Called when the node enters the scene tree for the first time.
func _ready():
	Level_Started.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
