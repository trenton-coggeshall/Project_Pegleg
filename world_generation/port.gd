extends Node2D

const AI_SHIP = preload("res://ai/ai_ship.tscn")

var location : Vector2i
var gold = 1000
var goods : Dictionary
var prices : Dictionary
var demand : Dictionary
var production : Dictionary
var faction = "none"
var paths : Dictionary


func _ready():
	initialize()


func _process(_delta):
	pass

func get_faction():
	return faction


func spawn_ship():
	var ai_ship = AI_SHIP.instantiate()
	ai_ship.path = random_path()
	add_child(ai_ship)


func set_faction(value):
	faction = value;

# Returns the price of a good at a certain quantity
func price_check(good, quantity):
	var base_price = EconomyGlobals.base_prices[good]
	var flux = float(quantity + 1) / float(demand[good])
	
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


func calculate_purchase(good, quantity):
	var cost = 0
	var current_price = prices[good]
	for i in range(quantity):
		cost += current_price
		current_price = price_check(good, goods[good] - (i + 1))
	return cost


func execute_purchase(good, quantity, cost):
	if goods[good] < quantity:
		print("Not enough goods in port inventory")
		return false
	
	if Player.gold < cost:
		print("Not enough player gold")
		return
	
	goods[good] -= quantity
	gold += cost
	set_price(good)
	return true


func calculate_sale(good, quantity):
	var net = 0
	var current_price = prices[good]
	for i in range(quantity):
		net += current_price
		current_price = price_check(good, goods[good] + (i + 1))
	return net


func execute_sale(good, quantity, cost):
	if gold < cost:
		print("Not enough gold in port inventory")
		return false
	
	goods[good] += quantity
	gold -= cost
	set_price(good)
	return true


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.set_near_port(true, self)
		DiscordSDK.details = ("Docked at " + self.name)
		DiscordSDK.refresh()


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		body.set_near_port(false, null)
		DiscordSDK.details = ("Sailing the high seas")
		DiscordSDK.refresh()


func random_path():
	var key = paths.keys()[randi() % len(paths.keys())]
	return paths[key].duplicate()


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("ai_ship"):
		area.get_parent().get_parent().current_port = self


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if not area:
		return

	if area.is_in_group("ai_ship"):
		area.get_parent().get_parent().current_port = null
