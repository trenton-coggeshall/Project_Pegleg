extends Control

@export var speedLabel:Label
@export var usernameLabel:Label
@export var goldLabel:Label

@export var healthBar:TextureProgressBar
@export var damageBar:TextureProgressBar

@export var settingsButton:Button
@export var settingsWindow:Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.hide_ui.connect(hide_UI)
	Signals.show_ui.connect(show_UI)
	Signals.speed_changed.connect(update_speed)
	Signals.gold_changed.connect(update_gold)
	Signals.username_changed.connect(set_username)
	
	Signals.player_damaged.connect(player_damaged)


#+------------------+
#| Signal Functions |
#+------------------+

func hide_UI():
	$CanvasLayer.visible = false
	
func show_UI():
	$CanvasLayer.visible = true

func update_speed(value):
	speedLabel.text = str(value)

func update_gold(value):
	goldLabel.text = str(value)

func set_username(value):
	usernameLabel.text = value
	
func player_damaged(value):
	var tween = create_tween()
	
	Player.health -= value
	
	tween.tween_property(healthBar, "value", Player.health, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(damageBar, "value", Player.health, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_settings_button_pressed():
	
	var closedPosition = Vector2(450, -500)
	var openPosition = Vector2(450, 60)
	var tween = get_tree().create_tween()
	
	if !settingsWindow.visible: # Open settings
		settingsWindow.visible = true
		settingsButton.disabled = true
		tween.tween_property(settingsWindow, "global_position", openPosition, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		await tween.finished
		settingsButton.disabled = false
	else: # Close settings
		settingsButton.disabled = true
		tween.tween_property(settingsWindow, "global_position", closedPosition, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		settingsWindow.visible = false
		settingsButton.disabled = false
