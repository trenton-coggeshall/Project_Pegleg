extends TileMap

const PORT = preload("res://world_generation/port.tscn")

var portNames:Array
var factions = ["RedTeam", "GreenTeam", "BlueTeam"]
var factionColors = {
	"RedTeam" = "#d82452",
	"GreenTeam" = "#2fb26e",
	"BlueTeam" = "#547ee7"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in len(WorldGlobals.ports):
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
	
	# Choose a port, assign a faction to it and its X closest neighbors
	for port in ports:
		if port.get_faction() != "none": continue
		
		print("=== " + port.name + " ===")
		var closest_num = 3 # Number of nearby ports to be assigned
		var closest_ports = []
		
		# Choose and assign a random faction from the faction list
		var thisFaction = factions[RandomNumberGenerator.new().randi_range(0, factions.size()-1)]
		port.set_faction(thisFaction)
		port.get_node("Icon").modulate = Color(factionColors[thisFaction])
		print("Faction: " + str(port.get_faction()))
		
		for subport in ports:
			if subport.get_faction() != "none": continue
			
			#Calculate distance between chosen port and current iteration
			var distvect = abs(port.global_position - subport.global_position)
			var distance = abs(distvect.x + distvect.y)
			if distance == 0: continue #yippee, you found yourself
			
			if closest_ports.size() < 3:
				closest_ports.append([subport, distance])
				continue
			for i in range(closest_ports.size()):
				var p = closest_ports[i]
				if distance < p[1]:
					closest_ports[i] = [subport, distance]
					break
		
		for i in range (closest_ports.size()):
			closest_ports[i][0].set_faction(thisFaction)
			closest_ports[i][0].get_node("Icon").modulate = Color(factionColors[thisFaction])
		
		print("Closest ports: ")
		for i in range(closest_ports.size()):
			print(closest_ports[i][0].name + " - " + str(closest_ports[i][1]) + " - " + closest_ports[i][0].get_faction())
