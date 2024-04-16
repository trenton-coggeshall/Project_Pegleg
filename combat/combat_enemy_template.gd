extends Node2D

@onready var combat_player = $"../CombatPlayer"
@onready var actual_ship = $Actual_Ship
@onready var pathnode = $Pathfinding_Node


var range = 800
var speed = 500

var playerInRange = false
var side

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Player.in_combat:
		return
	
	handle_sailing(delta)


func handle_sailing(delta):
	actual_ship.look_at(pathnode.global_position)
	actual_ship.global_position = actual_ship.global_position.lerp(pathnode.global_position, 5*delta)
	
	if pathnode.global_position.distance_to(combat_player.global_position) > range:
		pathnode.global_position = pathnode.global_position.move_toward(combat_player.global_position, speed * delta)
	else:
		var dir_to_player = (pathnode.global_position - combat_player.global_position).normalized()
		var move_dir = Vector2(dir_to_player.y, -dir_to_player.x) * 10
		pathnode.global_position = pathnode.global_position.move_toward(pathnode.global_position + move_dir, speed * delta)


func handle_shooting(delta):
	pass
	

func _on_player_detection_area_entered(area):
	if area.typeof(RayCast2D):
		print("PLAYER IN RANGE")
		playerInRange = true


func _on_player_detection_area_exited(area):
	if area.typeof(RayCast2D):
		print("PLAYER OUT OF RANGE")
		playerInRange = false


func _on_range_entered_right(area):
	print("Entered right: " + str(area))
	if area.name == "CombatHitbox":
		print("PLAYER IN RANGE: RIGHT")
		playerInRange = false
		side = "right"

func _on_range_entered_left(area):
	print("Entered lefft: " + str(area))
	if area.name == "CombatHitbox":
		print("PLAYER IN RANGE: LEFT")
		playerInRange = false
		side = "left"

func _on_range_exited(area):
	print("Exited: " + str(area))
	if area.name == "CombatHitbox":
		print("PLAYER OUT OF RANGE")
		playerInRange = false
		side = null
