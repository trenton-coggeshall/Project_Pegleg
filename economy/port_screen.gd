extends Control

@onready var home_screen = $HomeScreen
@onready var transaction_screen = $TransactionScreen

var port


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_port_screen():
	port = Player.current_port
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



