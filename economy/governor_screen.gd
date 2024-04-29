extends Control

@onready var home_screen = $"../HomeScreen"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_back_button_pressed():
	hide()
	home_screen.show()
