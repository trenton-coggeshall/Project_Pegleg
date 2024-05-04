extends Node2D
@onready var cannons_right_group = $"../CannonsRight"
@onready var cannons_left_group = $"../CannonsLeft"
@onready var parent = $".."
@export var Cannonball:PackedScene


var cannon_count = 0
var loaded_cannons = 0
var cannons_right:Array
var cannons_left:Array

var reload_timer = 0
var reload_delay = 0.5
var reload_amount = 1

var firing = false
var target
var target_dir : Vector2
var cannonball_speed = 1200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_reloading(delta)


func set_cannons(count):
	if count == cannon_count:
		return
	
	for i in cannon_count:
		cannons_left[i].queue_free()
		cannons_right[i].queue_free()
	cannons_left.clear()
	cannons_right.clear()
	
	#Have to wait a frame or the freed cannons will get added back to the arrays
	await get_tree().process_frame
	
	cannon_count = count
	var cannon_offset = 60.0 / cannon_count
	var y_pos = -(cannon_offset * cannon_count / 2)
	
	for i in cannon_count:
		var new_cannon_right = Marker2D.new()
		cannons_right_group.add_child(new_cannon_right)
		new_cannon_right.position.y = y_pos
		new_cannon_right.position.x = 30
		new_cannon_right.scale = Vector2(0.1, 0.1)
		
		var new_cannon_left = Marker2D.new()
		cannons_left_group.add_child(new_cannon_left)
		new_cannon_left.position.y = y_pos
		new_cannon_left.position.x = -30
		new_cannon_left.scale = Vector2(0.1, 0.1)
		new_cannon_left.rotation_degrees = 180
		
		y_pos += cannon_offset
		
	
	cannons_right = cannons_right_group.get_children()
	cannons_left = cannons_left_group.get_children()
	
	loaded_cannons = cannon_count


func fire():
	var cannons:Array
	
	if get_fire_direction():
		cannons = cannons_right
	else:
		cannons = cannons_left
	
	
	if loaded_cannons > 0:
		reload_timer = 0
	
	var shots = loaded_cannons
	loaded_cannons = 0
	
	cannons.shuffle()
	var shot_delay = 0
	firing = true
	
	#var angle = get_fire_angle(cannons) - parent.rotation
	#var original_angle = cannons[0].rotation
	#if abs(angle) > PI/4:
		#angle = original_angle

	for i in shots:
		#cannons[i].rotation = angle
		var projectile = Cannonball.instantiate()
		parent.get_parent().add_child(projectile)
		projectile.transform = cannons[i].global_transform
		projectile.global_position = cannons[i].global_position
		projectile.initialize(parent.velocity)
		#cannons[i].rotation = original_angle
		await get_tree().create_timer(shot_delay).timeout
		shot_delay = randf_range(0.01, 0.02)
	
	firing = false


func handle_reloading(delta):
	if loaded_cannons == cannon_count:
		return
	
	reload_timer += delta
	if reload_timer >= reload_delay:
		loaded_cannons = min(loaded_cannons + reload_amount, cannon_count)
		reload_timer = 0


func get_fire_direction():
	target_dir = parent.global_position.direction_to(target.global_position)
	
	if (-parent.transform.y).angle_to(target_dir) >= 0:
		return true
	else:
		return false


func get_fire_angle(cannons):
	var projectile_position = cannons[0].global_position
	var target_relative_position = target.global_position - projectile_position
	var distance_to_target = target_relative_position.length()
	var projectile_velocity = parent.velocity + transform.x * cannonball_speed
	var time_of_flight = distance_to_target / projectile_velocity.length()
	var relative_velocity = target.velocity - parent.velocity
	var predicted_position = target.global_position + relative_velocity * time_of_flight
	
	return (predicted_position - projectile_position).angle()
