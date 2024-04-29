extends Node

enum GoodType {
	FOOD = 0,
	FABRIC = 1,
	RUM = 2,
	LEATHER = 3,
	IRON = 4,
	LIVESTOCK = 5
}

const base_prices = {
	GoodType.FOOD: 5,
	GoodType.FABRIC: 6,
	GoodType.RUM: 7,
	GoodType.LEATHER: 8,
	GoodType.IRON: 10,
	GoodType.LIVESTOCK: 9
}

const demand_ranges = {
	GoodType.FOOD: [200, 300],
	GoodType.FABRIC: [25, 300],
	GoodType.RUM: [100, 400],
	GoodType.LEATHER: [50, 400],
	GoodType.IRON: [75, 450],
	GoodType.LIVESTOCK: [100, 300]
}

var port_prices : Dictionary
var price_limit_coef = 3


func average_prices():
	var sums : Dictionary = {}
	var avg : Dictionary = {}
	
	for good in GoodType.values():
		sums[good] = Vector2i(0, 0)
	
	for prices in port_prices:
		for good in GoodType.values():
			sums[good][0] += port_prices[prices][good][0]
			sums[good][1] += port_prices[prices][good][1]
	
	for good in GoodType.values():
		avg[good] = Vector2i(sums[good][0] / len(WorldGlobals.ports), sums[good][1] / len(WorldGlobals.ports))
	
	return avg


func find_arb(current_port):
	var best_price_diff = 1
	var good_type = null
	var avg = average_prices()
	
	for good in port_prices[current_port].keys():
		var price_diff =avg[good][1] - port_prices[current_port][good][0]
		if price_diff > best_price_diff:
			best_price_diff = price_diff
			good_type = good
	
	if not good_type:
		return null
	
	best_price_diff = 1
	var other_port = find_highest_price(good_type, current_port)
	
	if other_port == '':
		return null
	
	return [good_type, other_port]


func find_random_deal():
	var keys = base_prices.keys()
	var good_type = keys[randi() % len(keys)]
	var buy_port = find_lowest_price(good_type)
	var sell_port = find_highest_price(good_type)
	
	return [good_type, buy_port, sell_port]


func find_highest_price(good_type, exclude=''):
	var highest_price = 0
	var port_name = ''
	
	for port in port_prices.keys():
		if port_prices[port][good_type][1] > highest_price and port != exclude:
			highest_price = port_prices[port][good_type][1]
			port_name = port
	
	return port_name


func find_lowest_price(good_type, exclude=''):
	var lowest_price = 99999
	var port_name = ''
	
	for port in port_prices.keys():
		if port_prices[port][good_type][0] < lowest_price and port != exclude:
			lowest_price = port_prices[port][good_type][0]
			port_name = port
	
	return port_name
