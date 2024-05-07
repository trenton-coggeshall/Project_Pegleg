extends Node2D

const MERCHANT_AI = preload("res://ai/merchant_ai.tscn")
const MILITARY_AI = preload("res://ai/military_ai.tscn")

@onready var shipNames:Array = Names.ship_names

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

var merchant_ship

var merchant_respawn_delay = 120
var merchant_respawn_timer = 0.0

var sister_ports = []
var spawns_military = false
var military_ship
var military_respawn_delay = 120
var military_respawn_timer = 0.0


func _ready():
	EconomyGlobals.port_prices[name] = prices
	initialize()


func _process(delta):
	handle_production(delta)
	handle_consumption(delta)
	handle_crew_hires(delta)
	handle_ships(delta)


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


func handle_ships(delta):
	if not merchant_ship:
		merchant_respawn_timer += delta
		if merchant_respawn_timer >= merchant_respawn_delay:
			spawn_merchant()
			merchant_respawn_timer = 0
	
	if spawns_military and not military_ship:
		military_respawn_timer += delta
		if military_respawn_timer >= military_respawn_delay:
			spawn_military()
			military_respawn_timer = 0


func get_faction():
	return faction


func set_faction(value):
	faction = value;
	$Port_Flag.modulate = Color(FactionGlobals.faction_colors[value])

func spawn_merchant():
	var merchant = MERCHANT_AI.instantiate()
	get_parent().get_parent().add_child(merchant)
	merchant.ai_ship.name = str(shipNames[0])
	shipNames.remove_at(0)
	merchant.global_position = global_position
	merchant.home_port = self
	merchant.ai_ship.current_port = self
	merchant.ai_ship.path = random_path()
	merchant.ai_ship.faction = faction
	merchant.ai_ship.ship_sprite.modulate = Color(FactionGlobals.faction_colors[faction])
	merchant_ship = merchant


func spawn_military():
	#print("My faction: " + faction + '\n' + "Sister factions: " + '\n' + str(sistest[0]) + ' ' + str(sistest[1]) + ' ' + str(sistest[2]))
	
	
	var military = MILITARY_AI.instantiate()
	get_parent().get_parent().add_child(military)
	military.ai_ship.name = str(shipNames[0])
	shipNames.remove_at(0)
	military.global_position = global_position
	military.ports.append_array(sister_ports)
	military.ports.append(name)
	military.ai_ship.current_port = self
	military.ai_ship.path = paths[military.ports[0]]
	military.next_port = military.ai_ship.path[-1]
	military.ai_ship.faction = faction
	military.ai_ship.ship_sprite.modulate = Color(FactionGlobals.faction_colors[faction])
	
	military_ship = military
	


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


func get_refund(good, quantity):
	var total = 0
	
	for i in range(quantity):
		total += price_check(good, goods[good] + quantity - i)[0]
	
	return total


func buy_back(good, quantity):
	var total = 0
	
	for i in range(quantity):
		total += price_check(good, goods[good] - quantity + i)[1]
	
	return total


func get_next_buy_price_quant(good):
	var count = 0
	var start_price = prices[good][0]
	var current_price = start_price
	
	if start_price < EconomyGlobals.base_prices[good] * EconomyGlobals.price_limit_coef:
		while current_price == start_price:
			count += 1
			current_price = price_check(good, goods[good] - count)[0]
	else:
		count = Player.current_port.goods[good]
	
	return count


func get_next_sell_price_quant(good):
	var count = 0
	var start_price = prices[good][1]
	var current_price = start_price
	
	if start_price > 1:
		while current_price == start_price:
			count += 1
			current_price = price_check(good, goods[good] + count)[1]
	else:
		count = Player.inventory[good]
	
	return count


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


func _on_area_2d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.is_in_group("ai_ship"):
		area.get_parent().get_parent().current_port = self


func _on_area_2d_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	if not area:
		return

	if area.is_in_group("ai_ship") and area.get_parent().get_parent().current_port == self:
		area.get_parent().get_parent().current_port = null
