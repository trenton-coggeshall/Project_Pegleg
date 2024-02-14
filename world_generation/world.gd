extends Node2D

const CHUNK_TILES = preload("res://world_generation/chunk_tiles.tscn")

var chunks : Array

@onready var PlayerUI = get_node("/root/PlayerUI")

func _ready():
	for i in len(WorldGlobals.chunks):
		chunks.append(CHUNK_TILES.instantiate())
		add_child(chunks[i])
		chunks[i].initialize(WorldGlobals.chunks[i])


func _process(delta):
	pass

