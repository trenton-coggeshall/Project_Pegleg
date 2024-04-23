extends Node

enum TileType {
	WATER,
	SAND,
	LIGHT_GRASS,
	MED_GRASS,
	DARK_GRASS,
	SHALLOWS
}

# var chunks : Array
var tiles : Array
var ports
var map_height = 256
var map_width = 256


func random_port():
	var keys = ports.keys()
	return ports[keys[randi() % len(keys)]]
