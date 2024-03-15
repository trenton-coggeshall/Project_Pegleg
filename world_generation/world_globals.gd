extends Node

enum TileType {
	WATER,
	SAND,
	LIGHT_GRASS,
	MED_GRASS,
	DARK_GRASS
}

# var chunks : Array
var tiles : Array
var ports : Array
var map_height = 256
var map_width = 256
