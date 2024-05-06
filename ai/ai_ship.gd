extends Node2D

# Object References
@onready var world_tiles = $'../../WorldTiles'
@onready var path_finder = $'../../WorldTiles/path_finder'

@onready var pathnode = $Pathfinding_Node
@onready var actual_ship = $Actual_Ship
@onready var detect_radius = $Actual_Ship/Detection_Radius
@onready var node_radius = $Pathfinding_Node/Node_Radius
@onready var collision_shape_2d = $Actual_Ship/CollisionShape2D
@onready var ship_sprite = $Actual_Ship/Sprite2D

# Status
var anchored = false
var furled = false
var current_speed = 0
var near_port = false
var current_port = null
var target = null

# Speed
var max_speed = 500

var gold = 100
var inventory : Dictionary
var inv_limit = 30
var inv_occupied = 0

var faction

var destination
@export var path : Array
var path_index = 0

func _ready():
	for good in EconomyGlobals.GoodType.values():
		inventory[good] = 0 

func _physics_process(delta):
	if Player.in_combat:
		return
	
	handle_navigation(delta)
	pathnode.move_and_slide()

func handle_navigation(delta):
	
	if len(path) > path_index:
		# Move invisible node along A* path
		pathnode.global_position = pathnode.global_position.move_toward(path[path_index], max_speed * delta)
		
		# AI ship sprite lerps to node, not the path
		actual_ship.look_at(pathnode.global_position)
		actual_ship.global_position = actual_ship.global_position.lerp(pathnode.global_position, 5*delta)
		
		if pathnode.global_position.distance_to(path[path_index]) < 0.5:
			path_index += 1
	else:
		path = []
		path_index = 0
		destination = null


func update_inventory(gold_change, good_type, good_change):
	gold += gold_change
	inventory[good_type] += good_change
	inv_occupied += good_change


func destroy_ship():
	Names.ship_names.append(name)
	get_parent().queue_free()


func _on_detection_radius_body_entered(body):
	if body.is_in_group("Player") and len(path) > 0:
		destination = path[-1]
		target = body

func _on_detection_radius_body_exited(body):
	if body.is_in_group("Player") and destination:
		target = null
		path = path_finder.find_path(pathnode.global_position, destination)
		path_index = 0


func _on_visible_on_screen_notifier_2d_screen_entered():
	collision_shape_2d.disabled = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	collision_shape_2d.disabled = true
