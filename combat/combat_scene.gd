extends Node

@onready var combat_camera = $CombatCamera
@onready var combat_player = $CombatPlayer

var player_start
var ai_start


# Called when the node enters the scene tree for the first time.
func _ready():
	player_start = combat_player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_combat(enemy):
	Player.in_combat = true
	combat_camera.make_current()
