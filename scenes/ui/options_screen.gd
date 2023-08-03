extends Control
class_name OptionsScreen

@export var start_screen: StartScreen


func _on_back_pressed():
	hide()
	start_screen.show()


func _on_apply_pressed():
	save_options()
	hide()
	start_screen.show()


func save_options():
	pass

