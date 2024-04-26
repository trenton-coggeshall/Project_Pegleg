extends Node2D

@onready var combat_scene = get_parent()
@onready var combat_player = $"../CombatPlayer"
@onready var actual_ship = $Actual_Ship

@onready var cannon_controller = $Actual_Ship/CannonController

@onready var healthBar = $HealthBar
@onready var damageBar = $HealthBar/DamageBar


#@export var Cannonball:PackedScene
#@onready var cannonRight = $Actual_Ship/Cannons/cannonRight
#@onready var cannonLeft = $Actual_Ship/Cannons/cannonLeft

var range = 600
var max_speed = 17500
var acceleration = 5000
var steer_speed = 3
var max_health = 50
var health = 50

var current_speed = 0

var reload_delay = 0.75
var reload_timer = 0

var playerInRange = false
var side

var target_dir

# Called when the node enters the scene tree for the first time.
func _ready():
	cannon_controller.target = combat_player
	healthBar.max_value = max_health
	damageBar.max_value = max_health
	
	tween_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Player.in_combat:
		return
	
	healthBar.global_position = actual_ship.global_position - Vector2(50, -60)
	handle_sailing(delta)
	handle_shooting(delta)
	actual_ship.move_and_slide()


func handle_sailing(delta):
	current_speed += acceleration * delta
	if current_speed > max_speed:
		current_speed = max_speed
	
	if actual_ship.global_position.distance_to(combat_player.global_position) > range:
		target_dir = actual_ship.global_position.direction_to(combat_player.global_position)
	elif cannon_controller.loaded_cannons >= cannon_controller.cannon_count/2.0 or cannon_controller.firing:
		var dir_to_player = (actual_ship.global_position - combat_player.global_position).normalized()
		target_dir = Vector2(dir_to_player.y, -dir_to_player.x) * 10
	#else:
		#target_dir = combat_player.global_position.direction_to(actual_ship.global_position)
	
	var steer_dir
	if (-actual_ship.transform.y).angle_to(target_dir) >= 0:
		steer_dir = 1
	else:
		steer_dir = -1
	
	var turn_delta = steer_dir * steer_speed * delta
	actual_ship.rotate(turn_delta)
	actual_ship.velocity = -actual_ship.transform.y * current_speed * delta


func handle_shooting(delta):
	if playerInRange == false or cannon_controller.firing : return
	cannon_controller.fire()


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

func tween_health():
	var tween = create_tween()
	tween.tween_property(healthBar, "value", health, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(damageBar, "value", health, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func take_damage(damage):
	if health > 0 and Player.in_combat:
		health -= damage
		tween_health()
		if health == 0:
			Signals.end_combat.emit()
			Signals.show_end_screen_win.emit()
			health = max_health
			tween_health()
