extends Node2D

@onready var map_tiles = get_parent()

var astar_grid : AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready():
	init_grid()
	#print(find_path(Vector2i(0, 0), Vector2i(71, 125)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.size = Vector2i(WorldGlobals.map_width, WorldGlobals.map_height)
	astar_grid.cell_size = map_tiles.tile_set.tile_size
	astar_grid.update()
	
	for i in range(astar_grid.size.x):
		for j in range(astar_grid.size.y):
			var tile_type = WorldGlobals.tiles[i][j]
			astar_grid.set_point_solid(Vector2i(i, j), tile_type != WorldGlobals.TileType.WATER)


func find_path(start, end):
	return astar_grid.get_id_path(start, end)
