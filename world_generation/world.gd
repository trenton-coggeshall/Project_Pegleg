extends Node2D

const CHUNK_TILES = preload("res://world_generation/chunk_tiles.tscn")
const WORLD_TILES = preload("res://world_generation/world_tiles.tscn")

var chunks : Array
var tiles

@onready var PlayerUI = get_node("/root/PlayerUI")

func _ready():
	#for i in len(WorldGlobals.chunks):
		#chunks.append(CHUNK_TILES.instantiate())
		#add_child(chunks[i])
		#chunks[i].initialize(WorldGlobals.chunks[i])
	tiles = WORLD_TILES.instantiate()
	add_child(tiles)
	tiles.initialize()


func _process(delta):
	pass

