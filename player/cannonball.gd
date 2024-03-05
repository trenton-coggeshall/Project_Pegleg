extends Area2D

var speed = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		#body.queue_free()
		print("Hit enemy")
	queue_free()
