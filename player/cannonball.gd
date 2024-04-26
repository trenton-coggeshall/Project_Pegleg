extends Area2D

@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

var speed = 12000
var velocity = Vector2.ZERO
var range = 800
var distance_traveled = 0

var sunk = false
var sink_rate = 0.8

var damage = 5

func initialize(ship_velocity):
	velocity = ship_velocity
	velocity += transform.x * speed

func _physics_process(delta):
	var movement = velocity * delta
	distance_traveled += movement.length()
	global_position += movement
	
	if distance_traveled >= range and not sunk:
		sunk = true
		collision_shape_2d.disabled = true
		velocity = velocity / 10
		sprite.modulate.a = 0.25
	
	if sunk:
		sprite.modulate.a -= sink_rate * delta

func _on_body_entered(body):
	if body.name == "Actual_Ship":
		body.get_parent().take_damage(damage)
		print("Enemy hit. Damage: " + str(damage) + ". New health: " + str(body.get_parent().health))
	elif body.name == "CombatPlayer":
		Signals.player_damaged.emit(damage)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
