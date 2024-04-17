extends Control

@onready var home_screen = $HomeScreen
@onready var transaction_screen = $TransactionScreen
@onready var port_text = $HomeScreen/PortText
@onready var faction_text = $HomeScreen/FactionText
@onready var shipwright_screen = $ShipwrightScreen
@onready var tavern_screen = $TavernScreen
@onready var governor_screen = $GovernorScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.player_left_port.connect(_on_exit_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('cancel'):
		hide_port_screen()


func show_port_screen():
	port_text.text = Player.current_port.name
	faction_text.text = Player.current_port.faction
	show()
	get_tree().paused = true


func hide_port_screen():
	home_screen.show()
	governor_screen.hide()
	tavern_screen.hide()
	transaction_screen.hide()
	shipwright_screen.hide()
	hide()
	get_tree().paused = false


func _on_trade_button_pressed():
	transaction_screen.show_transaction()
	home_screen.hide()


func _on_shipwright_button_pressed():
	shipwright_screen.show_shipwright_screen()
	home_screen.hide()


func _on_tavern_button_pressed():
	tavern_screen.show()
	home_screen.hide()


func _on_governor_button_pressed():
	governor_screen.show()
	home_screen.hide()


func _on_exit_button_pressed():
	hide_port_screen()



