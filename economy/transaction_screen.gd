extends Control

const GOOD_LISTING = preload("res://economy/good_listing.tscn")

@onready var goods_container = $GoodsContainer
@onready var home_screen = $"../HomeScreen"
@onready var gold_change_text = $GoldChange

var good_listings : Dictionary

var gold_change = 0

var good_change = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_change_values()
	
	for good in EconomyGlobals.GoodType.values():
		good_listings[good] = GOOD_LISTING.instantiate()
		good_listings[good].set_title(EconomyGlobals.GoodType.find_key(good), good)
		goods_container.add_child(good_listings[good])


func reset_change_values():
	gold_change_text.text = 'Gold Change: 0'
	gold_change = 0
	for good in EconomyGlobals.GoodType.values():
		good_change[good] = 0


func finalize_transaction():
	Player.add_gold(gold_change)
	Player.current_port.gold -= gold_change


func show_transaction():
	$PortGold.text = 'Port gold: ' + str(Player.current_port.gold) + 'g'
	$PlayerGold.text = 'Your gold: ' + str(Player.gold) + 'g'
	for good in EconomyGlobals.GoodType.values():
		good_listings[good].set_price_quantity(Player.current_port.prices[good], Player.current_port.goods[good], Player.inventory[good])
	show()


func make_purchase(good, quantity):
	var total = 0
	var buy_back_quantity = 0
	
	while quantity > 0 and good_change[good] < 0:
		buy_back_quantity += 1
		quantity -= 1
		good_change[good] -= 1
	
	total += Player.current_port.buy_back(good, buy_back_quantity)
	total += Player.current_port.calculate_purchase(good, quantity)
	
	if total > Player.gold:
		print("Player does not have enough gold")
		return
	elif Player.inv_occupied + quantity > Player.inv_limit + Player.modifiers['cargo']:
		print("Not enough space in player inventory")
		return
	
	if Player.gold + gold_change - total >= 0:
		gold_change -= total
		good_change[good] += quantity + buy_back_quantity
		gold_change_text.text = 'Gold Change: ' + str(gold_change)
		Player.inventory[good] += quantity + buy_back_quantity
		Player.inv_occupied += quantity + buy_back_quantity
		Player.current_port.goods[good] -= quantity + buy_back_quantity
		Player.current_port.set_price(good)
		good_listings[good].set_price_quantity(Player.current_port.prices[good], Player.current_port.goods[good], Player.inventory[good])
		
	#if Player.current_port.execute_purchase(good, quantity, total):
		#Player.remove_gold(total)
		#Player.inventory[good] += quantity
		#Player.inv_occupied += quantity
		#good_listings[good].set_price_quantity(Player.current_port.prices[good], Player.current_port.goods[good], Player.inventory[good])
		#$PortGold.text = 'Port gold: ' + str(Player.current_port.gold) + 'g'
		#$PlayerGold.text = 'Your gold: ' + str(Player.gold) + 'g'


func make_sale(good, quantity):
	var total = 0
	var refund_quantity = 0
	
	while quantity > 0 and good_change[good] > 0:
		refund_quantity += 1
		quantity -= 1
		good_change[good] += 1
	
	total += Player.current_port.get_refund(good, refund_quantity)
	total += Player.current_port.calculate_sale(good, quantity)
	
	gold_change += total
	good_change[good] -= quantity + refund_quantity
	gold_change_text.text = 'Gold Change: ' + str(gold_change)
	Player.inventory[good] -= quantity + refund_quantity
	Player.inv_occupied -= quantity + refund_quantity
	Player.current_port.goods[good] += quantity + refund_quantity
	Player.current_port.set_price(good)
	good_listings[good].set_price_quantity(Player.current_port.prices[good], Player.current_port.goods[good], Player.inventory[good])
	
	#if Player.current_port.execute_sale(good, quantity, total):
		#Player.add_gold(total)
		#Player.inventory[good] -= quantity
		#Player.inv_occupied -= quantity
		#good_listings[good].set_price_quantity(Player.current_port.prices[good], Player.current_port.goods[good], Player.inventory[good])
		#$PortGold.text = 'Port gold: ' + str(Player.current_port.gold) + 'g'
		#$PlayerGold.text = 'Your gold: ' + str(Player.gold) + 'g'


func _on_back_button_pressed():
	hide()
	finalize_transaction()
	reset_change_values()
	home_screen.show()
