extends Node2D

var location
var gold = 1000
var goods : Dictionary
var prices : Dictionary
var demand : Dictionary
var production : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func price_check(good):
	var base_price = EconomyGlobals.base_prices[good]
	var flux = float(goods[good] + 1) / float(demand[good])
	prices[good] = int(round(base_price / flux))


func initialize():
	var ranges = EconomyGlobals.demand_ranges
	
	for good in EconomyGlobals.GoodType.values():
		goods[good] = randi_range(ranges[good][0], ranges[good][1])
		demand[good] = randi_range(ranges[good][0], ranges[good][1])
		price_check(good)
