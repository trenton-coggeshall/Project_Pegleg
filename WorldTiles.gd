extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

var width = 1024
var height = 1024
@onready var player = get_parent().get_child(1)

var m_seed = 123456
var t_seed = 654321
var a_seed = 987654

func _ready():
	moisture.seed = m_seed
	temperature.seed = t_seed
	altitude.seed = a_seed
	altitude.frequency = 0.005
	
	generate_chunk(player.position)


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		generate_chunk(player.position)

func populate_map():
	var chunk = WorldGlobals.chunks[0]
	
	var tile_pos = Vector2i()
	for i in range(len(chunk.tiles)):
		if tile_pos.x > chunk.size - 1:
			tile_pos.y += 1
			tile_pos.x = 0
		set_cell(0, tile_pos, 0, Vector2i())


func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var moist = moisture.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			var temp = temperature.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			var alt = altitude.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			if alt < 2:
				set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(3, 0))
			elif alt < 2.3 and moist < 2:
				set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(0, 3))
			else:
				set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(round((moist+10)/5), round((temp+10)/5)))
