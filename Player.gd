extends Node

#+--------------+
#| Player stats |
#+--------------+

var max_health = 100
var health = 100
var gold = 10000000
var inventory : Dictionary
var inv_limit = 30
var inv_occupied = 0
var current_port = null
var in_combat = false

#+-----------------+
#| Player Upgrades |
#+-----------------+

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

var wanted

func _ready():
	for good in EconomyGlobals.GoodType.values():
		inventory[good] = 0 
	Signals.gold_changed.emit(gold)


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
