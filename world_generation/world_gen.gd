extends Control

@onready var map_texture = $MapTexture
@onready var altitude_seed_text = $Seeds/AltitudeSeedText
@onready var temp_seed_text = $Seeds/TempSeedText
@onready var moisture_seed_text = $Seeds/MoistureSeedText
@onready var play_button = $PlayButton
@onready var generate_button = $GenerateButton
@onready var world_size_options = $WorldSizeOptions

const ChunkData = preload("res://world_generation/chunk_data.gd")

var map_width = 256
var map_height = 256

var gen_portions = 32

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

var tiles = [[WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS,  WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS, WorldGlobals.TileType.DARK_GRASS,  WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.SAND,       WorldGlobals.TileType.MED_GRASS,  WorldGlobals.TileType.MED_GRASS,   WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.SAND,       WorldGlobals.TileType.SAND,       WorldGlobals.TileType.LIGHT_GRASS, WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER],
			 [WorldGlobals.TileType.SAND,       WorldGlobals.TileType.SAND,       WorldGlobals.TileType.LIGHT_GRASS, WorldGlobals.TileType.WATER, WorldGlobals.TileType.WATER]]

var img = Image.create(map_width, map_height, false, Image.FORMAT_RGBA8)


var port_count = 4

var water_tiles = []

func _ready():
	Signals.hide_ui.emit()
	WorldGlobals.map_width = map_width
	WorldGlobals.map_height = map_height


func generate_map():
	play_button.disabled = true
	world_size_options.disabled = true
	water_tiles.clear()
	
	var map_tiles : Array
	
	for x in range(map_width):
		var y_tiles : Array
		for y in range(map_height):
			var moist = moisture.get_noise_2d(position.x + x, position.y + y)*10
			var temp = temperature.get_noise_2d(position.x + x, position.y + y)*10
			var alt = altitude.get_noise_2d(position.x + x, position.y + y)*10
			var test = Color.BLUE
			
			if alt < 2:
				water_tiles.append(Vector2i(x, y))
				#img.set_pixel(x + position.x, map_height - 1 - y, Color.BLUE) #water
				if alt < 1:
					y_tiles.append(WorldGlobals.TileType.WATER)
				else:
					y_tiles.append(WorldGlobals.TileType.SHALLOWS)
			elif alt < 2.3 and moist < 2:
				y_tiles.append(WorldGlobals.TileType.SAND)
				#chunk.possible_ports.append(Vector2i(x, y))
				#img.set_pixel(x + position.x, map_height - 1 - y, Color.BURLYWOOD) #sand
			else:
				y_tiles.append(tiles[round((moist+10)/5)][round((temp+10)/5)])
				#img.set_pixel(x + position.x, map_height - 1 - y, Color.WEB_GREEN) #land
			
			var pixel_color
			match y_tiles[y]:
				WorldGlobals.TileType.WATER:
					pixel_color = Color.DODGER_BLUE
				WorldGlobals.TileType.SAND:
					pixel_color = Color.BURLYWOOD
				WorldGlobals.TileType.LIGHT_GRASS:
					pixel_color = Color.LIME_GREEN
				WorldGlobals.TileType.MED_GRASS:
					pixel_color = Color.WEB_GREEN
				WorldGlobals.TileType.DARK_GRASS:
					pixel_color = Color.DARK_GREEN
				WorldGlobals.TileType.SHALLOWS:
					pixel_color = Color.SKY_BLUE
			img.set_pixel(x + position.x, map_height - 1 - y, pixel_color)
		
		map_tiles.append(y_tiles)
		
		if x % gen_portions == 0:
			map_texture.texture = ImageTexture.create_from_image(img)
			await get_tree().process_frame
	
	map_texture.texture = ImageTexture.create_from_image(img)
	WorldGlobals.tiles = map_tiles
	place_ports()
	
	play_button.disabled = false
	generate_button.disabled = false
	world_size_options.disabled = false


func place_ports():
	var total_ports = 0
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	while total_ports < port_count:
		var loc = water_tiles[randi() % len(water_tiles)]
		var dir = directions[randi() % len(directions)]
		var dist = 0
		
		while WorldGlobals.tiles[loc.x][loc.y] == WorldGlobals.TileType.WATER or WorldGlobals.tiles[loc.x][loc.y] == WorldGlobals.TileType.SHALLOWS:
			loc += dir
			dist += 1
			if loc.x < 0 or loc.x >= map_width or loc.y < 0 or loc.y >= map_height:
				break
			
			if WorldGlobals.tiles[loc.x][loc.y] != WorldGlobals.TileType.WATER and WorldGlobals.tiles[loc.x][loc.y] != WorldGlobals.TileType.SHALLOWS:
				if dist < 20:
					break
				var valid_placement = true
				for port in WorldGlobals.ports:
					if abs(port.x - loc.x) < 10 or abs(port.y - loc.y) < 10:
						valid_placement = false
						break
				if valid_placement:
					WorldGlobals.ports.append(loc - dir)
					total_ports += 1


func _on_generate_button_pressed():
	generate_button.disabled = true
	WorldGlobals.ports.clear()
	img = Image.create(map_width, map_height, false, Image.FORMAT_RGBA8)
	moisture.seed = int(moisture_seed_text.text)
	temperature.seed = int(temp_seed_text.text)
	altitude.seed = int(altitude_seed_text.text)
	altitude.frequency = 0.005
	
	generate_map()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://world_generation/world.tscn")


func _on_test_world_button_pressed():
	get_tree().change_scene_to_file("res://world_generation/PreBuiltWorld.tscn")


func _on_world_size_options_item_selected(index):
	match index:
		0:
			map_width = 256
			map_height = 256
			port_count = 4
		1: 
			map_width = 512
			map_height = 256
			port_count = 8
		2:
			map_width = 1024
			map_height = 512
			port_count = 20
		3: 
			map_width = 2048
			map_height = 1024
			port_count = 40
	
	WorldGlobals.map_width = map_width
	WorldGlobals.map_height = map_height
