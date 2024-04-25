extends Node2D

@onready var combat_scene = get_parent()
@onready var combat_player = $"../CombatPlayer"
@onready var actual_ship = $Actual_Ship

@export var Cannonball:PackedScene
@onready var cannonRight = $Actual_Ship/Cannons/cannonRight
@onready var cannonLeft = $Actual_Ship/Cannons/cannonLeft

var range = 800
var max_speed = 25000
var acceleration = 10000
var steer_speed = 3
var max_health = 100
var health = 100

var current_speed = 0

var reload_delay = 0.75
var reload_timer = 0

var playerInRange = false
var side

var target_dir

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Player.in_combat:
		return
	
	handle_sailing(delta)
	handle_shooting(delta)
	actual_ship.move_and_slide()


func handle_sailing(delta):
	current_speed += acceleration * delta
	if current_speed > max_speed:
		current_speed = max_speed
	
	if actual_ship.global_position.distance_to(combat_player.global_position) > range:
		target_dir = actual_ship.global_position.direction_to(combat_player.global_position)
	else:
		var dir_to_player = (actual_ship.global_position - combat_player.global_position).normalized()
		target_dir = Vector2(dir_to_player.y, -dir_to_player.x) * 10
	
	var steer_dir
	if (actual_ship.transform.x).angle_to(target_dir) >= 0:
		steer_dir = 1
	else:
		steer_dir = -1
	
	var turn_delta = steer_dir * steer_speed * delta
	actual_ship.rotate(turn_delta)
	actual_ship.velocity = actual_ship.transform.x * current_speed * delta

func handle_shooting(delta):
	reload_timer += delta
	if playerInRange == false or reload_timer < reload_delay: return
	reload_timer = 0
	if side == "right":
		var projectile = Cannonball.instantiate()
		get_parent().add_child(projectile)
		projectile.velocity = actual_ship.velocity * delta
		projectile.transform = cannonRight.global_transform
		projectile.global_position = cannonRight.global_position
	elif side == "left":
		var projectile = Cannonball.instantiate()
		get_parent().add_child(projectile)
		projectile.velocity = actual_ship.velocity * delta
		projectile.transform = cannonLeft.global_transform
		projectile.global_position = cannonLeft.global_position


func _on_range_entered_right(area):
	if area.name == "CombatHitbox":
		playerInRange = true
		side = "right"


func _on_range_entered_left(area):
	if area.name == "CombatHitbox":
		playerInRange = true
		side = "left"


func _on_range_exited(area):
	if area.name == "CombatHitbox":
		playerInRange = false
		side = null


func take_damage(damage):
	if health > 0:
		health -= damage
		if health == 0:
			Signals.end_combat.emit()
			health = max_health
