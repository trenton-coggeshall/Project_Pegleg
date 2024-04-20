extends Control

@onready var home_screen = $"../HomeScreen"
@onready var crew_screen = $"../CrewScreen"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	hide()
	home_screen.show()


func _on_hire_button_pressed():
	hide()
	crew_screen.show_crew_screen()
