extends Node2D

# Object References
@onready var world_tiles = $'../..'
@onready var path_finder = $'../../path_finder'

@onready var follownode = $follownode
@onready var aiship = $AI_Ship

# Status
var anchored = false
var furled = false
var current_speed = 0
var near_port = false
var current_port = null

# Speed
const max_speed = 500

var destination = WorldGlobals.ports[randi() % len(WorldGlobals.ports)]
var path : Array


func _physics_process(delta):
	handle_navigation(delta)
	follownode.move_and_slide()

func handle_navigation(delta):
	
	if len(path) > 0:
		
		# Move invisible node along A* path
		follownode.global_position = follownode.global_position.move_toward(path[0], max_speed * delta)
		
		# AI ship sprite lerps to node, not the path
		aiship.look_at(follownode.global_position)
		aiship.global_position = aiship.global_position.lerp(follownode.global_position, 5*delta)
		
		if follownode.global_position.distance_to(path[0]) < 0.5:
			path.pop_front()
		
	elif current_port:
		path = current_port.random_path()
