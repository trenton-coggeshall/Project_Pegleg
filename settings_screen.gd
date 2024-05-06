extends Control

@onready var home_screen = $"../HomeScreen"


func _on_back_button_pressed():
	hide()
	home_screen.show()


func _on_music_slider_value_changed(value):
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value):
	pass # Replace with function body.
