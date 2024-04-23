extends Node2D

@onready var ai_ship = $AI_Ship

var home_port

var buying = true
var making_deal = false
var returning = false
var current_good = null
var sell_port = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_destination()


func handle_destination():
	if len(ai_ship.path) == 0 and ai_ship.current_port:
		if returning:
			return_trip()
		elif making_deal:
			deal_purchase()
		elif buying:
			if randi() % 2 == 0:
				make_purchase()
			else:
				find_deal()
		elif ai_ship.current_port.name == sell_port:
			make_sale()
			
			if ai_ship.gold > 1500 and buying:
				returning = true
				if ai_ship.current_port != home_port:
					ai_ship.path = ai_ship.current_port.get_port_path(home_port.name)


func find_deal():
	making_deal = true
	var trade_data = EconomyGlobals.find_random_deal()
	current_good = trade_data[0]
	var buy_port = trade_data[1]
	sell_port = trade_data[2]
	
	if buy_port != ai_ship.current_port.name:
		ai_ship.path = ai_ship.current_port.get_port_path(buy_port)


func deal_purchase():
	var quantity = 0
	while ai_ship.current_port.calculate_purchase(current_good, quantity + 1) < ai_ship.gold \
		  and quantity + ai_ship.inv_occupied < ai_ship.inv_limit \
		  and quantity < ai_ship.current_port.goods[current_good]:
		quantity += 1
	
	var cost = ai_ship.current_port.calculate_purchase(current_good, quantity)
	
	ai_ship.current_port.execute_purchase(current_good, quantity, cost)
	ai_ship.update_inventory(-cost, current_good, quantity)
	#print("Bought " + str(quantity) + ' ' + str(current_good) + ' for ' + str(cost) + ' gold.')
	if sell_port != ai_ship.current_port.name:
		ai_ship.path = ai_ship.current_port.get_port_path(sell_port)
	#print("Path to " + sell_port + ": " + str(ai_ship.path))
	buying = false
	making_deal = false


func make_purchase():
	var trade_data = EconomyGlobals.find_arb(ai_ship.current_port.name)
	
	if not trade_data:
		#print("No trade data")
		ai_ship.path = ai_ship.current_port.random_path()
		return
	
	current_good = trade_data[0]
	sell_port = trade_data[1]
	
	#print("Current port: " + ai_ship.current_port.name + " Sell Port: " + sell_port)
	
	var quantity = 0
	while ai_ship.current_port.calculate_purchase(current_good, quantity + 1) < ai_ship.gold \
		  and quantity + ai_ship.inv_occupied < ai_ship.inv_limit \
		  and quantity < ai_ship.current_port.goods[current_good]:
		quantity += 1
	
	var cost = ai_ship.current_port.calculate_purchase(current_good, quantity)
	
	ai_ship.current_port.execute_purchase(current_good, quantity, cost)
	ai_ship.update_inventory(-cost, current_good, quantity)
	#print("Bought " + str(quantity) + ' ' + str(current_good) + ' for ' + str(cost) + ' gold.')
	ai_ship.path = ai_ship.current_port.get_port_path(sell_port)
	#print("Path to " + sell_port + ": " + str(ai_ship.path))
	buying = false


func make_sale():
	var quantity = ai_ship.inventory[current_good]
	var net = ai_ship.current_port.calculate_sale(current_good, quantity)
	
	while net > ai_ship.current_port.gold and quantity > 0:
		quantity -= 1
		if quantity > 0:
			net = ai_ship.current_port.calculate_sale(current_good, quantity)
		else:
			net = 0
	
	ai_ship.current_port.execute_sale(current_good, quantity, net)
	ai_ship.update_inventory(net, current_good, -quantity)
	#print("Sold " + str(quantity) + ' ' + str(current_good) + ' for ' + str(net) + ' gold.')
	
	if quantity < ai_ship.inv_occupied:
		sell_port = EconomyGlobals.find_highest_price(current_good, ai_ship.current_port.name)
		ai_ship.path = ai_ship.current_port.get_port_path(sell_port)
	else:
		buying = true


func return_trip():
	ai_ship.current_port.gold += ai_ship.gold - 100
	ai_ship.gold -= ai_ship.gold - 100
	returning = false
