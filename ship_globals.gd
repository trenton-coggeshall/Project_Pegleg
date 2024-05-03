extends Node

const SHIP_IMAGE = preload("res://ship.png")
const MILITARY_SHIP_IMAGE = preload("res://Assets/Images/military_ship.png")

var ship_stats = {
	'standard' : {
		'max_speed': 35000,
		'acceleration' : 10000,
		'max_furled_speed' : 25000,
		'furled_acceleration' : 5000,
		'turn_speed' : 3,
		'base_health' : 100,
		'inv_limit' : 30,
		'crew_max' : 80,
		'crew_optimal' : 60,
		'sprite' : SHIP_IMAGE
	},
	'military' : {
		'max_speed': 30000,
		'acceleration' : 100000,
		'max_furled_speed' : 25000,
		'furled_acceleration' : 5000,
		'turn_speed' : 2.5,
		'base_health' : 100,
		'inv_limit' : 30,
		'crew_max' : 100,
		'crew_optimal' : 80,
		'sprite' : MILITARY_SHIP_IMAGE
	},
}
