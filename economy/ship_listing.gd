extends VBoxContainer

@onready var ship_label = $ShipLabel
@onready var ship_image = $ShipImage
@onready var speed_text = $HBoxContainer/SpeedText
@onready var cargo_text = $HBoxContainer/CargoText
@onready var hull_text = $HBoxContainer/HullText
@onready var crew_text = $HBoxContainer/CrewText
@onready var price_text = $HBoxContainer2/PriceText
@onready var buy_button = $BuyButton

var ship_key

var ship_owned = false
var ship_equipped = false


func _ready():
	Signals.player_ship_changed.connect(check_button)


func _process(delta):
	check_button()


func initialize(key):
	ship_key = key
	
	var stats = ShipGlobals.ship_stats[key]
	ship_label.text = stats['name']
	ship_image.texture = stats['sprite']
	speed_text.text = 'Speed: ' + str(stats['max_speed'] / 10000)
	cargo_text.text = 'Cargo Space: ' + str(stats['inv_limit'])
	hull_text.text = 'Hull Strength: ' + str(stats['base_health'])
	crew_text.text = 'Crew Capacity: ' + str(stats['crew_max'])
	price_text.text = 'Price: ' + str(stats['price']) + 'g'
	buy_button.text = 'Buy'
	
	check_button()



func _on_buy_button_pressed():
	if ship_owned:
		equip_ship()
	else:
		buy_ship()


func buy_ship():
	Player.ships_owned.append(ship_key)
	Player.remove_gold(ShipGlobals.ship_stats[ship_key]['price'])
	Player.current_port.gold += ShipGlobals.ship_stats[ship_key]['price']
	buy_button.text = "Use Ship"
	price_text.text = ''
	ship_owned = true


func equip_ship():
	Player.set_ship(ship_key)
	
	ship_equipped = true
	check_button()


func check_button():
	if ship_key != Player.current_ship and ship_owned:
		buy_button.disabled = false
		buy_button.text = "Use Ship"
	elif ship_key == Player.current_ship:
		ship_owned = true
		buy_button.text = "Using Ship"
		buy_button.disabled = true
		
	if ship_owned:
		price_text.text = ''
	
	if not ship_owned and Player.gold < ShipGlobals.ship_stats[ship_key]['price']:
		buy_button.disabled = true
	elif not ship_owned:
		buy_button.disabled = false
