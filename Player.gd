extends Node

#+--------------+
#| Player stats |
#+--------------+

var health = 100
var gold = 100
var inventory : Dictionary
var current_port = null



# Called when the node enters the scene tree for the first time.
func _ready():
	for good in EconomyGlobals.GoodType.values():
		inventory[good] = 0 
