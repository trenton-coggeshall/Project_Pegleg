extends CharacterBody2D


const max_speed = 50000
const acceleration = 10000
const anchor_acceleration = 50000
const max_furled_speed = 25000
const furled_acceleration = 5000
const turn_speed = 3
const anchorspeed = 0

var anchored = false
var furled = false
var current_speed = 0

func _physics_process(delta):
	handle_rotation(delta)
	handle_sails(delta)
	move_and_slide()
	handle_anchor(delta)

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
	
func handle_anchor(delta):
	if anchored:
		if Input.is_action_just_pressed('anchor'):
			anchored = false
			furled = true
			$Sprite2D/Anchor.visible = false
		current_speed = move_toward(current_speed, 0, anchor_acceleration * delta)
	else:
		if Input.is_action_just_pressed('anchor'):
			anchored = true
			$Sprite2D/Anchor.visible = true
