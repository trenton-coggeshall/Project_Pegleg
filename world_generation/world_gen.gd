extends Control

@onready var map_texture = $MapTexture
@onready var altitude_seed_text = $Seeds/AltitudeSeedText
@onready var temp_seed_text = $Seeds/TempSeedText
@onready var moisture_seed_text = $Seeds/MoistureSeedText

const ChunkData = preload("res://world_generation/chunk_data.gd")

var map_width = 2048
var map_height = 1024
var chunk_size = 512

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

var tiles = [[WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS,  WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS,  WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.SAND,       WorldGlobals.TileType.MED_GRASS,  WorldGlobals.TileType.MED_GRASS,   WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.SAND,       WorldGlobals.TileType.SAND,       WorldGlobals.TileType.LIGHT_GRASS, WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.SAND,       WorldGlobals.TileType.SAND,       WorldGlobals.TileType.LIGHT_GRASS, WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER]]

var img = Image.create(map_width, map_height, false, Image.FORMAT_RGBA8)

var port_count = 20
var viable_port_locations : Array

func _ready():
	pass


func _process(delta):
	pass


func generate_map():
	var chunk_pos = Vector2i()
	
	var c_width = map_width/chunk_size
	var c_height = map_height/chunk_size
	
	for i in c_height:
		for j in c_width:
			generate_chunk(chunk_pos)
			chunk_pos.x += chunk_size
			map_texture.texture = ImageTexture.create_from_image(img)
			await get_tree().process_frame
		chunk_pos.y += chunk_size
		chunk_pos.x = 0
	
	place_ports()
	map_texture.texture = ImageTexture.create_from_image(img)

func generate_chunk(position):
	var chunk = ChunkData.new(position, chunk_size)
	chunk.position = position
	chunk.size = chunk_size
	
	for y in range(chunk_size):
		for x in range(chunk_size):
			var moist = moisture.get_noise_2d(position.x + x, position.y + y)*10
			var temp = temperature.get_noise_2d(position.x + x, position.y + y)*10
			var alt = altitude.get_noise_2d(position.x + x, position.y + y)*10
			
			if alt < 2:
				chunk.tiles.append(WorldGlobals.TileType.WATER)
				img.set_pixel(x + position.x, y + position.y, Color.BLUE) #water
			elif alt < 2.3 and moist < 2:
				chunk.tiles.append(WorldGlobals.TileType.SAND)
				chunk.possible_ports.append(Vector2i(x, y))
				img.set_pixel(x + position.x, y + position.y, Color.BURLYWOOD) #sand
			else:
				chunk.tiles.append(tiles[round((moist+10)/5)][round((temp+10)/5)])
				img.set_pixel(x + position.x, y + position.y, Color.WEB_GREEN) #land
	
	WorldGlobals.chunks.append(chunk)


func place_ports():
	var total_ports = 0
	
	while total_ports < port_count:
		var chunk = WorldGlobals.chunks[randi() % len(WorldGlobals.chunks)]
		var selected_loc = chunk.possible_ports[randi() % len(chunk.possible_ports)]
		chunk.ports.append(selected_loc)
		for x in range(50):
			for y in range(50):
				chunk.possible_ports.erase(Vector2i(x, y) + selected_loc)
				chunk.possible_ports.erase(Vector2i(x, -y) + selected_loc)
				chunk.possible_ports.erase(Vector2i(-x, y) + selected_loc)
				chunk.possible_ports.erase(Vector2i(-x, -y) + selected_loc)
				
		total_ports += 1


func _on_generate_button_pressed():
	WorldGlobals.chunks.clear()
	img = Image.create(map_width, map_height, false, Image.FORMAT_RGBA8)
	moisture.seed = int(moisture_seed_text.text)
	temperature.seed = int(temp_seed_text.text)
	altitude.seed = int(altitude_seed_text.text)
	altitude.frequency = 0.005
	
	generate_map()
	Signals.set_username.emit("balls")


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://world_generation/world.tscn")
