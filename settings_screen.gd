extends Control

@onready var home_screen = $"../HomeScreen"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	hide()
	home_screen.show()


func _on_music_slider_value_changed(value):
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value):
	pass # Replace with function body.
