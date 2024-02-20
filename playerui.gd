extends Control

@export var speedLabel:Label
@export var usernameLabel:Label

@export var healthBar:TextureProgressBar
@export var damageBar:TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.hide_ui.connect(hide_UI)
	Signals.show_ui.connect(show_UI)
	Signals.speed_changed.connect(update_speed)
	Signals.username_changed.connect(set_username)
	
	Signals.player_damaged.connect(player_damaged)

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
	
func player_damaged(value):
	var tween = create_tween()
	
	Player.health -= value
	
	tween.tween_property(healthBar, "value", Player.health, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(damageBar, "value", Player.health, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
