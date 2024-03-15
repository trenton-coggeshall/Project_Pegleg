extends Node2D

const CHUNK_TILES = preload("res://world_generation/chunk_tiles.tscn")
const WORLD_TILES = preload("res://world_generation/world_tiles.tscn")
const AI_SHIP = preload("res://ai/ai_ship.tscn")
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
	
	for i in range(len(WorldGlobals.ports)):
		var ai_ship = AI_SHIP.instantiate()
		ai_ship.position = tiles.map_to_local(WorldGlobals.ports[i])
		add_child(ai_ship)


func _process(_delta):
	pass

