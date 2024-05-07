extends Node2D

@onready var ai_ship = $AI_Ship
@onready var detection_radius = $AI_Ship/Actual_Ship/Detection_Radius
@onready var combat_scene = $"../CombatScene"

var ports = []
var port_index = 0

var target = null
var next_port

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = detection_radius.get_overlapping_bodies()
	target = null
	for body in bodies:
		if body.is_in_group("Player") and FactionGlobals.reputation[ai_ship.faction] < 0:
			target = body
			break
	
	if target: # Player in detection radius AND is hostile
		ai_ship.path = ai_ship.path_finder.find_path(ai_ship.pathnode.global_position, target.global_position)
		
		if ai_ship.actual_ship.global_position.distance_to(target.global_position) < 125:
			combat_scene.start_combat(ai_ship)
		
	elif len(ai_ship.path) == 0 and ai_ship.current_port != null:
		port_index = (port_index + 1) % len(ports)
		ai_ship.path = ai_ship.current_port.paths[ports[port_index]]
		next_port = ai_ship.path[-1]
	elif target == null and len(ai_ship.path) == 0:
		ai_ship.path = ai_ship.path_finder.find_path(ai_ship.pathnode.global_position, next_port)
