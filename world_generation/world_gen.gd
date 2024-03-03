extends Control

@onready var map_texture = $MapTexture
@onready var altitude_seed_text = $Seeds/AltitudeSeedText
@onready var temp_seed_text = $Seeds/TempSeedText
@onready var moisture_seed_text = $Seeds/MoistureSeedText
@onready var play_button = $PlayButton

const ChunkData = preload("res://world_generation/chunk_data.gd")
const CHUNK_TILES = preload("res://world_generation/chunk_tiles.tscn")

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

var port_count = 40
var water_tiles = []

func _ready():
	Signals.hide_ui.emit()
	pass


# Using this for UI debug
func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		Signals.player_damaged.emit(10)


func generate_map():
	play_button.disabled = true
	
	var map_tiles : Array
	
	for x in range(map_width):
		var y_tiles : Array
		for y in range(map_height):
			var moist = moisture.get_noise_2d(position.x + x, position.y + y)*10
			var temp = temperature.get_noise_2d(position.x + x, position.y + y)*10
			var alt = altitude.get_noise_2d(position.x + x, position.y + y)*10
			
			if alt < 2:
				water_tiles.append(Vector2i(x, y))
				y_tiles.append(WorldGlobals.TileType.WATER)
				img.set_pixel(x + position.x, y + position.y, Color.BLUE) #water
			elif alt < 2.3 and moist < 2:
				y_tiles.append(WorldGlobals.TileType.SAND)
				#chunk.possible_ports.append(Vector2i(x, y))
				img.set_pixel(x + position.x, y + position.y, Color.BURLYWOOD) #sand
			else:
				y_tiles.append(tiles[round((moist+10)/5)][round((temp+10)/5)])
				img.set_pixel(x + position.x, y + position.y, Color.WEB_GREEN) #land
		
		map_tiles.append(y_tiles)
		map_texture.texture = ImageTexture.create_from_image(img)
		await get_tree().process_frame
	
	WorldGlobals.tiles = map_tiles
	place_ports()
	
	play_button.disabled = false


func place_ports():
	var total_ports = 0
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	while total_ports < port_count:
		var loc = water_tiles[randi() % len(water_tiles)]
		var dir = directions[randi() % len(directions)]
		var dist = 0
		
		while WorldGlobals.tiles[loc.x][loc.y] == WorldGlobals.TileType.WATER:
			loc += dir
			dist += 1
			if loc.x < 0 or loc.x >= map_width or loc.y < 0 or loc.y >= map_height:
				break
			
			if WorldGlobals.tiles[loc.x][loc.y] != WorldGlobals.TileType.WATER:
				if dist < 20:
					break
				var valid_placement = true
				for port in WorldGlobals.ports:
					if abs(port.x - loc.x) < 10 or abs(port.y - loc.y) < 10:
						valid_placement = false
						break
				if valid_placement:
					WorldGlobals.ports.append(loc)
					total_ports += 1


func _on_generate_button_pressed():
	#WorldGlobals.chunks.clear()
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
