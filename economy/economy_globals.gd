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
var price_limit_coef = 5


func average_prices():
	var sums : Dictionary
	var avg : Dictionary
	
	for good in GoodType.values():
		sums[good] = 0
	
	for prices in port_prices:
		for good in GoodType.values():
			sums[good] += port_prices[prices][good]
	
	for good in GoodType.values():
		avg[good] = sums[good] / len(WorldGlobals.ports)
	
	return avg


func find_arb(current_port):
	var best_price_diff = 1
	var good_type = null
	
	for good in port_prices[current_port].keys():
		var price_diff = float(base_prices[good]) / float(port_prices[current_port][good][0])
		if price_diff > best_price_diff:
			best_price_diff = price_diff
			good_type = good
	
	if not good_type:
		return null
	
	best_price_diff = 1
	var other_port = ''
	
	for p in port_prices.keys():
		var price_diff = float(port_prices[p][good_type][1]) / float(base_prices[good_type])
		if price_diff > best_price_diff:
			best_price_diff = price_diff
			other_port = p
	
	if other_port == '':
		return null
	
	return [good_type, other_port]


func find_highest_price(good_type, exclude=''):
	var highest_price = 0
	var port_name = ''
	
	for port in port_prices.keys():
		if port_prices[port][good_type] > highest_price and port != exclude:
			highest_price = port_prices[port][good_type]
			port_name = port
	
	return port_name
