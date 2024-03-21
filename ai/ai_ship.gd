extends Node2D

# Object References
@onready var world_tiles = $'../WorldTiles'
@onready var path_finder = $'../WorldTiles/path_finder'

@onready var pathnode = $Pathfinding_Node
@onready var aiship = $Actual_Ship

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
	pathnode.move_and_slide()

func handle_navigation(delta):
	
	if len(path) > 0:
		
		# Move invisible node along A* path
		pathnode.global_position = pathnode.global_position.move_toward(world_tiles.map_to_local(path[0]), max_speed * delta)
		
		# AI ship sprite lerps to node, not the path
		aiship.look_at(pathnode.global_position)
		aiship.global_position = aiship.global_position.lerp(pathnode.global_position, 5*delta)
		
		if pathnode.global_position.distance_to(world_tiles.map_to_local(path[0])) < 0.5:
			path.pop_front()
		
	elif current_port:
		path = current_port.random_path()
