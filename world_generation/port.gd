extends Node2D

const MERCHANT_AI = preload("res://ai/merchant_ai.tscn")
const MILITARY_AI = preload("res://ai/military_ai.tscn")

var location : Vector2i
var gold = 10000
var goods : Dictionary
var prices : Dictionary
var demand : Dictionary
var production : Dictionary
var consumption : Dictionary
var faction = "none"
var region = "none"
var paths : Dictionary
var max_goods = 500
var hireable_crew = 0
var crew_refresh_delay = 10
var crew_refresh_timer = 10
var crew_cost = 0

var production_timer = 0
var production_rate = 10
var consumption_timer = 0
var consumption_rate = 10

var upgrade_types = []


func _ready():
	EconomyGlobals.port_prices[name] = prices
	initialize()


func _process(delta):
	handle_production(delta)
	handle_consumption(delta)
	handle_crew_hires(delta)


func handle_production(delta):
	production_timer += delta
	
	if production_timer >= production_rate:
		production_timer = 0
		
		for good in EconomyGlobals.GoodType.values():
			if goods[good] > demand[good]:
				goods[good] += int(production[good] * min(float(demand[good]) / float(goods[good]), 2))
			if goods[good] > max_goods:
				goods[good] = max_goods
			set_price(good)


func handle_consumption(delta):
	consumption_timer += delta
	
	if consumption_timer >= consumption_rate:
		consumption_timer = 0
		
		for good in EconomyGlobals.GoodType.values():
			if goods[good] < demand[good]:
				goods[good] -= int(consumption[good] * min(float(goods[good]) / float(demand[good]), 2))
			if goods[good] < 0:
				goods[good] = 0
			set_price(good)


func handle_crew_hires(delta):
	crew_refresh_timer += delta
	
	if crew_refresh_timer >= crew_refresh_delay:
		crew_refresh_timer = 0
		hireable_crew = randi_range(5, 15)
		crew_cost = randi_range(1, 5)


func get_faction():
	return faction


func set_faction(value):
	faction = value;


func spawn_ship():
	var merchant = MERCHANT_AI.instantiate()
	merchant.name = self.name + "_AI_Ship"
	get_parent().get_parent().add_child(merchant)
	merchant.global_position = global_position
	merchant.home_port = self
	merchant.ai_ship.current_port = self
	merchant.ai_ship.path = random_path()
	merchant.ai_ship.faction = self.faction


# Returns the price of a good at a certain quantity
func price_check(good, quantity):
	var base_price = EconomyGlobals.base_prices[good]
	var flux = float(quantity + 1) / float(demand[good])
	var price = clamp(int(round(base_price / flux)), 1, EconomyGlobals.price_limit_coef * base_price)
	var sell_price = max(price - max(base_price * 0.1, 1), 1)
	var buy_price = price + max(base_price * 0.1, 1)
	
	return Vector2i(buy_price, sell_price)


# Sets the price of a good based on the current quantity held by the port
func set_price(good):
	prices[good] = price_check(good, goods[good])


func initialize():
	var ranges = EconomyGlobals.demand_ranges
	
	for good in EconomyGlobals.GoodType.values():
		goods[good] = randi_range(ranges[good][0], ranges[good][1])
		demand[good] = randi_range(ranges[good][0], ranges[good][1])
		production[good] = randi_range(0, 20)
		consumption[good] = max(production[good] + randi_range(-10, 10), 0)
		set_price(good)


func calculate_purchase(good, quantity):
	var cost = 0
	var current_price = prices[good][0]
	for i in range(quantity):
		cost += current_price
		var price = price_check(good, goods[good] - (i + 1))
		current_price = price[0]
	return cost


func execute_purchase(good, quantity, cost):
	if goods[good] < quantity:
		print("Not enough goods in port inventory")
		return false
	
	goods[good] -= quantity
	gold += cost
	set_price(good)
	return true


func calculate_sale(good, quantity):
	var net = 0
	var current_price = prices[good][1]
	for i in range(quantity):
		net += current_price
		var price = price_check(good, goods[good] - (i + 1))
		current_price = price[1]
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
	if body.is_in_group("Player") and Player.current_port == self:
		body.set_near_port(false, null)
		Signals.player_left_port.emit()
		DiscordSDK.details = ("Sailing the high seas")
		DiscordSDK.refresh()


func random_path():
	var key = paths.keys()[randi() % len(paths.keys())]
	return paths[key]


func get_port_path(port_name):
	return paths[port_name]


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("ai_ship"):
		area.get_parent().get_parent().current_port = self


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if not area:
		return

	if area.is_in_group("ai_ship") and area.get_parent().get_parent().current_port == self:
		area.get_parent().get_parent().current_port = null
