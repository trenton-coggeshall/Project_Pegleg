extends Camera2D

var zoom_amount = Vector2(0.05, 0.05)
var max_zoom = Vector2(2, 2)
var min_zoom = Vector2(0.1, 0.1)
var current_zoom = zoom
var zoom_speed = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_zoom(delta)
	


func handle_zoom(delta):
	if Input.is_action_just_pressed("scroll_up"):
		current_zoom += current_zoom * 0.25
		if current_zoom > max_zoom:
			current_zoom = max_zoom
	elif Input.is_action_just_pressed(("scroll_down")):
		current_zoom -= current_zoom * 0.25
		if current_zoom < min_zoom:
			current_zoom = min_zoom
			
	
	#zoom = current_zoom
	zoom = zoom.move_toward(current_zoom, zoom_speed * zoom.length() * delta)
