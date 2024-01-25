extends Node2D

const CHUNK_TILES = preload("res://world_generation/chunk_tiles.tscn")

#@onready var temp_player = $TempPlayer

var chunks : Array
var chunk_offset : Vector2i

var update_timer = 0.1

func _ready():
	chunk_offset = Vector2i(WorldGlobals.chunks[0].size/2, WorldGlobals.chunks[0].size/2)
	for i in len(WorldGlobals.chunks):
		chunks.append(CHUNK_TILES.instantiate())
		add_child(chunks[i])
		chunks[i].initialize(WorldGlobals.chunks[i])


func _process(delta):
	pass


#func update_chunks(delta):
	#update_timer -= delta
	#if update_timer <= 0:
		#for i in range(len(chunks)):
			#print(temp_player.position.distance_to(WorldGlobals.chunks[i].position + chunk_offset))
			#if not chunks[i].is_processing() and temp_player.position.distance_to((WorldGlobals.chunks[i].position + chunk_offset) * 16) < 8192:
				#print("enabled")
				#add_child(chunks[i])
				#chunks[i].set_process(true)
				#
			#elif chunks[i].is_processing() and temp_player.position.distance_to((WorldGlobals.chunks[i].position + chunk_offset) * 16) >= 8192:
				#print('disabled')
				#remove_child(chunks[i])
				#chunks[i].set_process(false)
		#update_timer = 1.0
