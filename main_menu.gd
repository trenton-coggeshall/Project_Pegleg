extends Control

@onready var home_screen = $HomeScreen
@onready var world_gen_screen = $WorldGenScreen
@onready var settings_screen = $SettingsScreen


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	home_screen.hide()
	world_gen_screen.show()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	home_screen.hide()
	settings_screen.show()
