extends Node2D

@onready var ai_ship = $AI_Ship

var buying = true
var current_good = null
var sell_port = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_destination()


func handle_destination():
	if len(ai_ship.path) == 0 and ai_ship.current_port:
		if buying:
			make_purchase()
		elif ai_ship.current_port.name == sell_port:
			make_sale()


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
	while ai_ship.current_port.calculate_purchase(current_good, quantity + 1) < ai_ship.gold:
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
	ai_ship.current_port.execute_sale(current_good, quantity, net)
	ai_ship.update_inventory(net, current_good, -quantity)
	#print("Sold " + str(quantity) + ' ' + str(current_good) + ' for ' + str(net) + ' gold.')
	buying = true
