extends Node2D

@onready var ai_ship = $AI_Ship

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ai_ship.target and Player.wanted: # Player in detection radius AND is hostile
		ai_ship.path = ai_ship.path_finder.find_path(ai_ship.pathnode.global_position, ai_ship.target.global_position)
