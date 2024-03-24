extends Area2D

var speed = 1000
var velocity = Vector2.ZERO

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta
	global_position += velocity

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		#body.queue_free() -- Damage Enemy
		print("Hit enemy")
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
