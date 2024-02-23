extends TileMap

const PORT = preload("res://world_generation/port.tscn")

var portNames:Array
var factions = ["BobsClub", "Faction2", "UniqueName"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 50:
		portNames.append("Port" + str(n+1))


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
		
		var rng = RandomNumberGenerator.new()
		var rand = rng.randi_range(0, portNames.size()-1)
		port.name = portNames[rand]
		portNames.remove_at(rand)
		
		add_child(port)

	var ports = get_tree().get_nodes_in_group("Ports")
	for port in ports:
		
		#if port.get_faction() != "none":
			print("=== " + port.name + " ===")
			var rng = RandomNumberGenerator.new()
			var closest_ports = [[null, INF], [null, INF], [null, INF]]
			
			#port.set_faction(rng.randi_range(0, factions.size()-1))
			for subport in ports:
				var distvect = abs(port.global_position - subport.global_position)
				var distance = abs(distvect.x + distvect.y)
				if distance != 0:
					for i in range(closest_ports.size()):
						var p = closest_ports[i]
						if distance < p[1]:
							closest_ports[i] = [subport, distance]
							break;
			print("Closest ports: ")
			for i in range(closest_ports.size()):
				print(closest_ports[i][0].name + " - " + str(closest_ports[i][1]))
	
