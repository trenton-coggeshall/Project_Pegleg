extends Control

const GOOD_LISTING = preload("res://economy/good_listing.tscn")

@onready var goods_container = $GoodsContainer

var good_listings : Dictionary
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	for good in EconomyGlobals.GoodType.values():
		good_listings[good] = GOOD_LISTING.instantiate()
		good_listings[good].set_title(EconomyGlobals.GoodType.find_key(good), good)
		goods_container.add_child(good_listings[good])


func show_transaction():
	var port = player.current_port
	$PortGold.text = 'Port gold: ' + str(port.gold) + 'g'
	$PlayerGold.text = 'Your gold: ' + str(player.gold) + 'g'
	for good in EconomyGlobals.GoodType.values():
		good_listings[good].set_price_quantity(port.prices[good], port.goods[good], player.inventory[good])
	show()


func make_purchase(good, quantity):
	var total = player.current_port.calculate_purchase(good, quantity)
	player.current_port.execute_purchase(good, quantity, total)
	player.gold -= total
	player.inventory[good] += quantity
	good_listings[good].set_price_quantity(player.current_port.prices[good], player.current_port.goods[good], player.inventory[good])
	$PortGold.text = 'Port gold: ' + str(player.current_port.gold) + 'g'
	$PlayerGold.text = 'Your gold: ' + str(player.gold) + 'g'

func make_sale(good, quantity):
	var total = player.current_port.calculate_sale(good, quantity)
	player.current_port.execute_sale(good, quantity, total)
	player.gold += total
	player.inventory[good] -= quantity
	good_listings[good].set_price_quantity(player.current_port.prices[good], player.current_port.goods[good], player.inventory[good])
	$PortGold.text = 'Port gold: ' + str(player.current_port.gold) + 'g'
	$PlayerGold.text = 'Your gold: ' + str(player.gold) + 'g'
