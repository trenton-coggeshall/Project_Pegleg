extends Area2D

@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

var speed = 1000
var velocity = Vector2.ZERO
var range = 800
var distance_traveled = 0

var sunk = false
var sink_rate = 0.8

var damage = 5

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	var dist = direction * speed * delta
	distance_traveled += dist.length()
	global_position += dist
	global_position += velocity
	
	if distance_traveled >= range and not sunk:
		sunk = true
		collision_shape_2d.disabled = true
		speed = speed / 10
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
