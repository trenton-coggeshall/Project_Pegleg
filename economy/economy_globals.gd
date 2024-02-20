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
	GoodType.FOOD: [200, 500],
	GoodType.FABRIC: [25, 300],
	GoodType.RUM: [100, 600],
	GoodType.LEATHER: [50, 400],
	GoodType.IRON: [75, 450],
	GoodType.LIVESTOCK: [100, 500]
}

var port_prices : Dictionary
