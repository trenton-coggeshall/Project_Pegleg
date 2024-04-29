extends Camera2D

var zoom_amount = Vector2(0.05, 0.05)
var max_zoom = Vector2(2, 2)
var min_zoom = Vector2(0.1, 0.1)
var current_zoom = zoom
var zoom_speed = 5
var edge_buffer = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	limit_left = -edge_buffer * 16
	limit_right = (WorldGlobals.map_width + edge_buffer) * 16
	limit_top = -edge_buffer * 16
	limit_bottom = (WorldGlobals.map_height + edge_buffer) * 16
	
	var view_port = get_viewport().size
	var zoom_lim = max(1.0/(limit_right / view_port.x), 1.0/(limit_bottom / view_port.y))
	min_zoom = Vector2(zoom_lim, zoom_lim)
	
	if zoom.x < min_zoom.x:
		current_zoom = min_zoom
		zoom = min_zoom


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
