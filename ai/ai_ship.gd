extends Node2D

# Object References
@onready var world_tiles = $'../WorldTiles'
@onready var path_finder = $'../WorldTiles/path_finder'

@onready var pathnode = $Pathfinding_Node
@onready var aiship = $Actual_Ship
@onready var detect_radius = $Actual_Ship/Detection_Radius
@onready var node_radius = $Pathfinding_Node/Area2D

# Status
var anchored = false
var furled = false
var current_speed = 0
var near_port = false
var current_port = null
var target = null

# Speed
const max_speed = 500

var destination = WorldGlobals.ports[randi() % len(WorldGlobals.ports)]
@export var path : Array


func _physics_process(delta):
	handle_navigation(delta)
	pathnode.move_and_slide()

func handle_navigation(delta):
	
	if target: # Player in detection radius
		pathnode.global_position = pathnode.global_position.move_toward(target.global_position, max_speed*delta)
		aiship.look_at(pathnode.global_position)
		aiship.global_position = aiship.global_position.lerp(pathnode.global_position, 5*delta)
		return
	
	if len(path) > 0:
		# Move invisible node along A* path
		pathnode.global_position = pathnode.global_position.move_toward(path[0], max_speed * delta)
		
		# AI ship sprite lerps to node, not the path
		aiship.look_at(pathnode.global_position)
		aiship.global_position = aiship.global_position.lerp(pathnode.global_position, 5*delta)
		
		if pathnode.global_position.distance_to(path[0]) < 0.5:
			path.pop_front()
		
	elif current_port:
		path = current_port.random_path()


func _on_detection_radius_body_entered(body):
	if body.is_in_group("Player"):
		target = body

func _on_detection_radius_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		path = path_finder.find_path(pathnode.global_position, path[-1])
