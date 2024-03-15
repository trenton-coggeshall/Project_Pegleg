extends CharacterBody2D

@onready var world_tiles = $'../WorldTiles'
@onready var path_finder = $'../WorldTiles/path_finder'

# Speed
const max_speed = 50000
const acceleration = 10000
const anchor_acceleration = 50000
const max_furled_speed = 25000
const furled_acceleration = 5000
const turn_speed = 3
const anchorspeed = 0

# Status
var anchored = false
var furled = false
var current_speed = 0
var near_port = false
var current_port = null

var destination = WorldGlobals.ports[randi() % len(WorldGlobals.ports)]
var path : Array
var port_index = 0


func _ready():
	path = path_finder.find_path(world_tiles.local_to_map(position), destination)
	print(len(path))


func _physics_process(delta):
	handle_navigation(delta)
	move_and_slide()


func handle_navigation(delta):
	if len(path) > 0:
		position = position.move_toward(world_tiles.map_to_local(path[0]), 500 * delta)
		if position.distance_to(world_tiles.map_to_local(path[0])) < 0.5:
			path.pop_front()
	else:
		destination = WorldGlobals.ports[randi() % len(WorldGlobals.ports)]
		path = path_finder.find_path(world_tiles.local_to_map(position), destination)
