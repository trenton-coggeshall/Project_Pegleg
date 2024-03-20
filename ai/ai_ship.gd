extends CharacterBody2D

@onready var world_tiles = $'../..'
@onready var path_finder = $'../../path_finder'

# Status
var anchored = false
var furled = false
var current_speed = 0
var near_port = false
var current_port = null

var destination = WorldGlobals.ports[randi() % len(WorldGlobals.ports)]
var path : Array

# Speed
const max_speed = 500
const acceleration = 10000
const anchor_acceleration = 50000
const max_furled_speed = 25000
const furled_acceleration = 5000
const turn_speed = 3
const anchorspeed = 0



func _ready():
	pass

func _physics_process(delta):
	handle_navigation(delta)
	move_and_slide()

func handle_navigation(delta):
	
	if len(path) > 0:
		global_position = global_position.move_toward(world_tiles.map_to_local(path[0]), 500 * delta)
		if global_position.distance_to(world_tiles.map_to_local(path[0])) < 0.5:
			path.pop_front()
	elif current_port:
		path = current_port.random_path()
