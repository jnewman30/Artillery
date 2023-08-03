extends Control
class_name StartScreen

@export var play_screen: PlayScreen
@export var options_screen: OptionsScreen
@export var quit_dialog: ConfirmationDialog

@onready var game_scene = preload("res://scenes/game.tscn")

var game_instance: Control

func _on_play_pressed():
	print_debug('Play Pressed')
	hide()
	play_screen.show()



func _on_options_pressed():
	print_debug('Options Pressed')
	options_screen.show()
	hide()
	



func _on_exit_pressed():
	print_debug('Exit Pressed')
	quit_dialog.title = "Exit Game?"
	quit_dialog.dialog_text = "Are you sure?"
	quit_dialog.ok_button_text = "YES"
	quit_dialog.cancel_button_text = "No"
	quit_dialog.show()



func _on_quit_dialog_confirmed():
	print_debug('Exit Confirmed')
	get_tree().quit(0)


func _on_play_screen_play_pressed():
	if !game_instance: game_instance = game_scene.instantiate()
	get_tree().root.add_child(game_instance)
	get_parent().hide()
	


func _on_play_screen_back_pressed():
	print_debug('Back from Play Screen')
	play_screen.hide()
	show()



func _on_options_screen_apply_pressed():
	print_debug('Apply from Options Screen')
	options_screen.hide()
	show()



func _on_options_screen_back_pressed():
	print_debug('Back from Options Screen')
	options_screen.hide()
	show()


