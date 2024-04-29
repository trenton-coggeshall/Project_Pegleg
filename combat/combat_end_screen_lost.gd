extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	Signals.show_end_screen_lose.connect(show_lose_screen)


func show_lose_screen():
	get_tree().paused = true
	show()


func _on_button_leave_pressed():
	get_tree().paused = false
	hide()
