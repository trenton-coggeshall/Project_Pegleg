extends Node

#+--------------+
#| Player stats |
#+--------------+

var max_health = 100
var health = 100
var gold = 5000
var inventory : Dictionary
var inv_occupied = 0
var crew_count = 60
var crew_modifier
var current_port = null
var in_combat = false

#+-----------------+
#| Player Upgrades |
#+-----------------+

var stats = {
	'max_speed': 0,
	'acceleration' : 0,
	'max_furled_speed' : 0,
	'furled_acceleration' : 0,
	'turn_speed' : 0,
	'base_health' : 0,
	'inv_limit' : 0,
	'base_cannons' : 0,
	'crew_max' : 80,
	'crew_optimal' : 60,
	'sprite' : null
	}

var upgrades = {
	"health" : [],
	"cargo" : [],
	"speed" : [],
	"steering" : [],
}

var modifiers = {
	"health" : 0,
	"cargo" : 0,
	"speed" : 0,
	"steering" : 0,
}

var ships_owned = ['standard']
var current_ship = 'standard'


func _ready():
	set_ship(ships_owned[0])
	for good in EconomyGlobals.GoodType.values():
		inventory[good] = 0 
	Signals.gold_changed.emit(gold)
	crew_check()


func add_gold(amt):
	gold += amt
	Signals.gold_changed.emit(gold)
	DiscordSDK.state = "Money: " + str(Player.gold) + "g"
	DiscordSDK.refresh()


func remove_gold(amt):
	gold -= amt
	Signals.gold_changed.emit(gold)
	DiscordSDK.state = "Money: " + str(Player.gold) + "g"
	DiscordSDK.refresh()


func add_upgrade(type, upgrade_name):
	upgrades[type].append(upgrade_name)
	
	var upgrade = UpgradeGlobals.UPGRADE_LIST[type][upgrade_name]
	var modifier_keys = upgrade['stat_changes'].keys()
	
	for m in modifier_keys:
		modifiers[m] += upgrade['stat_changes'][m]
		if m == 'health':
			max_health = Player.stats['base_health'] + modifiers['health']
			Signals.player_update_max_health.emit()
			Signals.player_healed.emit(max_health)


func add_crew(amt):
	crew_count += amt
	if crew_count > Player.stats['crew_max']:
		crew_count = Player.stats['crew_max']
	crew_check()


func remove_crew(amt):
	crew_count -= amt
	if crew_count < 0:
		crew_count = 0
	crew_check()


func crew_check():
	if crew_count < Player.stats['crew_optimal']:
		crew_modifier = max(float(crew_count) / float(Player.stats['crew_optimal']), 0.1)
	else:
		crew_modifier = 1


func get_inventory_space():
	return stats['inv_limit'] + modifiers['cargo'] - inv_occupied


func set_ship(ship_name):
	stats = ShipGlobals.ship_stats[ship_name]
	max_health = stats['base_health'] + modifiers['health']
	current_ship = ship_name
	Signals.player_update_max_health.emit()
	Signals.player_healed.emit(max_health)	
	Signals.player_ship_changed.emit()
	Signals.player_update_max_crew.emit()
	
