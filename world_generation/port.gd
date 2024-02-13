extends Node2D

var location
var gold = 1000
var goods : Dictionary
var prices : Dictionary
var demand : Dictionary
var production : Dictionary


func _ready():
	initialize()
	calculate_transaction(EconomyGlobals.GoodType.FOOD, 100)


func _process(delta):
	pass


# Returns the price of a good at a certain quantity
func price_check(good, quantity):
	var base_price = EconomyGlobals.base_prices[good]
	var flux = float(goods[good] + 1) / float(demand[good])
	
	return int(round(base_price / flux))


# Sets the price of a good based on the current quantity held by the port
func set_price(good):
	prices[good] = price_check(good, goods[good])


func initialize():
	var ranges = EconomyGlobals.demand_ranges
	
	for good in EconomyGlobals.GoodType.values():
		goods[good] = randi_range(ranges[good][0], ranges[good][1])
		demand[good] = randi_range(ranges[good][0], ranges[good][1])
		set_price(good)


func calculate_transaction(good, quantity):
	print("Starting price: " + str(prices[good]))
	var cost = 0
	for i in range(quantity):
		cost += prices[good]
		goods[good] -= 1
		set_price(good)
	
	print("Ending price: " + str(prices[good]))
	print("Total cost: " + str(cost))


