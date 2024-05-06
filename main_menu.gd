extends Control

@onready var home_screen = $HomeScreen
@onready var world_gen_screen = $WorldGenScreen
@onready var settings_screen = $SettingsScreen


func _on_play_button_pressed():
	home_screen.hide()
	world_gen_screen.show()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	home_screen.hide()
	settings_screen.show()
