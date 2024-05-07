extends Node2D

@onready var ai_ship = $AI_Ship

var ports = []
var port_index = 0


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ai_ship.target: # Player in detection radius AND is hostile
		ai_ship.path = ai_ship.path_finder.find_path(ai_ship.pathnode.global_position, ai_ship.target.global_position)
	elif len(ai_ship.path) == 0 and ai_ship.current_port != null:
		port_index = (port_index + 1) % len(ports)
		ai_ship.path = ai_ship.current_port.paths[ports[port_index]]
