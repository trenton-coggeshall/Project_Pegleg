extends TileMap

const PORT = preload("res://world_generation/port.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func initialize(chunk_data):
	var tile_pos = Vector2i()
	
	for i in range(len(chunk_data.tiles)):
		if i % chunk_data.size == 0:
			tile_pos.x = 0
			tile_pos.y += 1
		
		match chunk_data.tiles[i]:
			WorldGlobals.TileType.WATER:
				set_cell(0, Vector2i(tile_pos.x + chunk_data.position.x, tile_pos.y + chunk_data.position.y), 0, Vector2i(3, 0))
			WorldGlobals.TileType.SAND:
				set_cell(0, Vector2i(tile_pos.x + chunk_data.position.x, tile_pos.y + chunk_data.position.y), 0, Vector2i(0, 3))
			WorldGlobals.TileType.LIGHT_GRASS:
				set_cell(0, Vector2i(tile_pos.x + chunk_data.position.x, tile_pos.y + chunk_data.position.y), 0, Vector2i(2, 3))
			WorldGlobals.TileType.MED_GRASS:
				set_cell(0, Vector2i(tile_pos.x + chunk_data.position.x, tile_pos.y + chunk_data.position.y), 0, Vector2i(1, 2))
			WorldGlobals.TileType.DARK_GRASS:
				set_cell(0, Vector2i(tile_pos.x + chunk_data.position.x, tile_pos.y + chunk_data.position.y), 0, Vector2i(1, 1))
		
		tile_pos.x += 1
	
	for port_location in chunk_data.ports:
		var port = PORT.instantiate()
		port.position = (port_location + chunk_data.position) * 16
		add_child(port)
