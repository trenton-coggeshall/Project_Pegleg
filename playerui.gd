extends Control

@export var speedLabel:Label
@export var usernameLabel:Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.hide_ui.connect(hide_UI)
	Signals.show_ui.connect(show_UI)
	Signals.speed_changed.connect(update_speed)
	Signals.username_changed.connect(set_username)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass

#+------------------+
#| Signal Functions |
#+------------------+

func hide_UI():
	$CanvasLayer.visible = false
	
func show_UI():
	$CanvasLayer.visible = true

func update_speed(value):
	speedLabel.text = str(value)

func set_username(value):
	usernameLabel.text = value
