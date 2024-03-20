extends Node2D

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
const acceleration = 10000
const anchor_acceleration = 50000
const max_furled_speed = 25000
const furled_acceleration = 5000
const turn_speed = 3
const anchorspeed = 0

var destination = WorldGlobals.ports[randi() % len(WorldGlobals.ports)]
var path : Array

func _ready():
	pass

func _physics_process(delta):
	handle_navigation(delta)
	follownode.move_and_slide()

func handle_navigation(delta):
	
	if len(path) > 0:
		follownode.global_position = follownode.global_position.move_toward(world_tiles.map_to_local(path[0]), 500 * delta)
		
		follownode.look_at(world_tiles.map_to_local(path[0]))
		aiship.look_at(follownode.global_position)
		aiship.global_position = aiship.global_position.lerp(follownode.global_position, 5*delta)
		
		if follownode.global_position.distance_to(world_tiles.map_to_local(path[0])) < 0.5:
			path.pop_front()
	elif current_port:
		path = current_port.random_path()
