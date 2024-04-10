extends Control

@onready var home_screen = $HomeScreen
@onready var transaction_screen = $TransactionScreen
@onready var port_text = $HomeScreen/PortText
@onready var faction_text = $HomeScreen/FactionText


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_port_screen():
	port_text.text = Player.current_port.name
	faction_text.text = Player.current_port.faction
	show()
	get_tree().paused = true


func hide_port_screen():
	hide()
	get_tree().paused = false


func _on_trade_button_pressed():
	transaction_screen.show_transaction()
	home_screen.hide()


func _on_exit_button_pressed():
	hide_port_screen()



