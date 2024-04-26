extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	Signals.show_end_screen_lose.connect(show_lose_screen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_lose_screen():
	show()

func _on_button_leave_pressed():
	pass # Replace with function body.
	hide()
