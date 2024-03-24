extends Control

const GOOD_LISTING = preload("res://economy/good_listing.tscn")

@onready var goods_container = $GoodsContainer

var good_listings : Dictionary
var port

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Signals.player_left_port.connect(_on_button_pressed)
	
	for good in EconomyGlobals.GoodType.values():
		good_listings[good] = GOOD_LISTING.instantiate()
		good_listings[good].set_title(EconomyGlobals.GoodType.find_key(good), good)
		goods_container.add_child(good_listings[good])


func show_transaction():
	port = Player.current_port
	$PortGold.text = 'Port gold: ' + str(port.gold) + 'g'
	$PlayerGold.text = 'Your gold: ' + str(Player.gold) + 'g'
	for good in EconomyGlobals.GoodType.values():
		good_listings[good].set_price_quantity(port.prices[good], port.goods[good], Player.inventory[good])
	show()


func make_purchase(good, quantity):
	var total = Player.current_port.calculate_purchase(good, quantity)
	if Player.current_port.execute_purchase(good, quantity, total):
		Player.remove_gold(total)
		Player.inventory[good] += quantity
		good_listings[good].set_price_quantity(Player.current_port.prices[good], Player.current_port.goods[good], Player.inventory[good])
		$PortGold.text = 'Port gold: ' + str(Player.current_port.gold) + 'g'
		$PlayerGold.text = 'Your gold: ' + str(Player.gold) + 'g'


func make_sale(good, quantity):
	var total = Player.current_port.calculate_sale(good, quantity)
	if Player.current_port.execute_sale(good, quantity, total):
		Player.add_gold(total)
		Player.inventory[good] -= quantity
		good_listings[good].set_price_quantity(Player.current_port.prices[good], Player.current_port.goods[good], Player.inventory[good])
		$PortGold.text = 'Port gold: ' + str(Player.current_port.gold) + 'g'
		$PlayerGold.text = 'Your gold: ' + str(Player.gold) + 'g'


func _on_button_pressed():
	hide()
