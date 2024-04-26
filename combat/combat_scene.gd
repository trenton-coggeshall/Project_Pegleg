extends Node

@onready var normal_camera = $"../PlayerShip/Camera2D"
@onready var combat_camera = $CombatCamera
@onready var combat_player = $CombatPlayer

@onready var combat_enemy_ship = $CombatEnemyTemplate/Actual_Ship

var player_start
var ai_start_ship
var ai_start_node


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.start_combat.connect(start_combat)
	Signals.end_combat.connect(end_combat)
	player_start = combat_player.position
	ai_start_ship = combat_enemy_ship.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_combat(enemy):
	Player.in_combat = true
	combat_camera.make_current()
	Signals.showReloadTimer.emit()

func end_combat():
	Player.in_combat = false
	normal_camera.make_current()
	$CombatPlayer.position = player_start
	$CombatEnemyTemplate/Actual_Ship.position = ai_start_ship
	Signals.hideReloadTimer.emit()
