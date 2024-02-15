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
	$GoodPrice.text = str(price) + 'g'
	
	if port_quantity == 0:
		$Buy1Button.disabled = true
	else:
		$Buy1Button.disabled = false
	
	if player_quantity == 0:
		$Sell1Button.disabled = true
	else:
		$Sell1Button.disabled = false


func _on_buy_1_button_pressed():
	transaction_screen.make_purchase(id, 1)


func _on_sell_1_button_pressed():
	transaction_screen.make_sale(id, 1)
