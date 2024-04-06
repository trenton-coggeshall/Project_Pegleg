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
	$BuyPrice.text = 'Buy: ' + str(price[0]) + 'g'
	$SellPrice.text = 'Sell: ' + str(price[1]) + 'g'
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
