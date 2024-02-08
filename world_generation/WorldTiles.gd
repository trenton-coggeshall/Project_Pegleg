extends TileMap

const PORT = preload("res://world_generation/port.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func initialize():
	var tiles = WorldGlobals.tiles
	for x in range(len(tiles)):
		for y in range(len(tiles[x])):
			match tiles[x][y]:
				WorldGlobals.TileType.WATER:
					set_cell(0, Vector2i(x, y), 0, Vector2i(3, 0))
				WorldGlobals.TileType.SAND:
					set_cell(0, Vector2i(x, y), 0, Vector2i(0, 3))
				WorldGlobals.TileType.LIGHT_GRASS:
					set_cell(0, Vector2i(x, y), 0, Vector2i(2, 3))
				WorldGlobals.TileType.MED_GRASS:
					set_cell(0, Vector2i(x, y), 0, Vector2i(1, 2))
				WorldGlobals.TileType.DARK_GRASS:
					set_cell(0, Vector2i(x, y), 0, Vector2i(1, 1))
	
	for loc in WorldGlobals.ports:
		var port = PORT.instantiate()
		port.position = loc * 16
		add_child(port)
