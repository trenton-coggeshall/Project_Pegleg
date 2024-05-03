extends HBoxContainer

@onready var transaction_screen = get_node("../..")

var title = ''
var port_quantity = 0
var player_quantity = 0
var price = 0
var id


func set_title(g_title, g_id):
	title = g_title
	id = g_id
	$GoodTitle.text = title

func set_price_quantity(g_price, po_quantity, pl_quantity):
	port_quantity = po_quantity
	player_quantity = pl_quantity
	price = g_price
	$PortQuantity.text = str(port_quantity)
	$PlayerQuantity.text = str(player_quantity)
	$BuyPrice.text = str(price[0]) + 'g'
	$SellPrice.text = str(price[1]) + 'g'
	check_buttons()


func check_buttons():
	$ButtonContainer/Buy1Button.disabled = port_quantity <= 0
	$ButtonContainer/Buy10Button.disabled = port_quantity < 10
	$ButtonContainer/BuyMaxButton.disabled = port_quantity <= 0
	$ButtonContainer/Sell1Button.disabled = player_quantity <= 0
	$ButtonContainer/Sell10Button.disabled = player_quantity < 10
	$ButtonContainer/SellMaxButton.disabled = player_quantity <= 0


func _on_buy_1_button_pressed():
	transaction_screen.make_purchase(id, 1)


func _on_sell_1_button_pressed():
	transaction_screen.make_sale(id, 1)


func _on_buy_10_button_pressed():
	transaction_screen.make_purchase(id, 10)


func _on_sell_10_button_pressed():
	transaction_screen.make_sale(id, 10)


func _on_buy_max_button_pressed():
	var count = Player.current_port.get_next_buy_price_quant(id)
	count = min(count, Player.get_inventory_space())
	
	if Player.current_port.calculate_purchase(id, count) > Player.gold:
		count = floor(Player.gold / Player.current_port.prices[id][0])
	
	transaction_screen.make_purchase(id, count)


func _on_sell_max_button_pressed():
	var count = Player.current_port.get_next_sell_price_quant(id)
	count = min(count, Player.inventory[id])
	
	if Player.current_port.calculate_sale(id, count) > Player.current_port.gold:
		count = floor(Player.current_port.gold / Player.current_port.prices[id][1])
		
	
	transaction_screen.make_sale(id, count)
