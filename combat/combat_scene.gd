extends Node

@onready var normal_camera = $"../PlayerShip/Camera2D"
@onready var combat_camera = $CombatCamera
@onready var combat_player = $CombatPlayer

@onready var combat_enemy_ship = $CombatEnemyTemplate/Actual_Ship

var ai_node

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
func _process(_delta):
	pass


func start_combat(enemy):
	Player.in_combat = true
	ai_node = enemy
	combat_player.ship_sprite.texture = Player.stats['sprite']
	combat_player.cannon_controller.set_cannons(Player.stats['base_cannons'])
	combat_enemy_ship.get_parent().cannon_controller.set_cannons(5)
	combat_enemy_ship.get_parent().ship_sprite.texture = enemy.stats['ai_sprite']
	combat_enemy_ship.get_parent().ship_sprite.modulate = Color(FactionGlobals.faction_colors[ai_node.faction])
	combat_camera.make_current()
	Signals.showReloadTimer.emit()

func end_combat():
	Player.in_combat = false
	if combat_enemy_ship.get_parent().health <= 0:
		FactionGlobals.reputation[ai_node.faction] -= 10
		ai_node.destroy_ship()
		Signals.show_end_screen_win.emit(ai_node)
	
	if Player.health <= 0:
		FactionGlobals.reputation[ai_node.faction] -= 5
		Signals.player_healed.emit(10)
		Signals.show_end_screen_lose.emit()
	
	normal_camera.make_current()
	$CombatPlayer.position = player_start
	$CombatEnemyTemplate/Actual_Ship.position = ai_start_ship
	Signals.hideReloadTimer.emit()
