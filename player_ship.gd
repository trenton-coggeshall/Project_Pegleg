extends CharacterBody2D


const max_speed = 50000
const acceleration = 10000
const max_furled_speed = 25000
const furled_acceleration = 5000
const turn_speed = 3

var furled = false
var current_speed = 0


func _physics_process(delta):
	handle_rotation(delta)
	handle_sails(delta)
	move_and_slide()

func handle_rotation(delta):
	var turn_delta = Input.get_axis('left', 'right') * turn_speed * delta
	rotate(turn_delta)

func handle_sails(delta):
	if furled:
		if Input.is_action_just_pressed('up'):
			furled = false
		current_speed = move_toward(current_speed, max_furled_speed, furled_acceleration * delta)
	else:
		if Input.is_action_just_pressed('down'):
			furled = true
		current_speed = move_toward(current_speed, max_speed, acceleration * delta)
	
	velocity = -transform.y * current_speed * delta
