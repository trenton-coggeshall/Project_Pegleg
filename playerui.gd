extends Control

@export var speedLabel:Label
@export var usernameLabel:Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_PlayerShip_speed_changed(speed):
	pass

func hide_UI():
	$CanvasLayer.visible = false
	
func show_UI():
	$CanvasLayer.visible = true

func update_speed(value):
	speedLabel.text = str(value)

func update_username(value):
	usernameLabel.text = value
