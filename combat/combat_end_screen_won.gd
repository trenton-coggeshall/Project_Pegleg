extends Control

@onready var victory_text = $victory_text
@onready var button_leave = $Button_leave
@onready var loot_gold_text = $ScrollContainer/VBoxContainer/loot_gold_text
@onready var button_food = $ScrollContainer/VBoxContainer/Button_food
@onready var button_fabric = $ScrollContainer/VBoxContainer/Button_fabric
@onready var button_rum = $ScrollContainer/VBoxContainer/Button_rum
@onready var button_leather = $ScrollContainer/VBoxContainer/Button_leather
@onready var button_iron = $ScrollContainer/VBoxContainer/Button_iron
@onready var button_livestock = $ScrollContainer/VBoxContainer/Button_livestock
@onready var loot_found_text = $loot_found_text
@onready var inventory_text = $inventory_text

var buttons

var won = true

var gold = 0

var goods = {
	EconomyGlobals.GoodType.FOOD: 0,
	EconomyGlobals.GoodType.FABRIC: 0,
	EconomyGlobals.GoodType.RUM: 0,
	EconomyGlobals.GoodType.LEATHER: 0,
	EconomyGlobals.GoodType.IRON: 0,
	EconomyGlobals.GoodType.LIVESTOCK: 0,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	Signals.show_end_screen_win.connect(show_win_screen)
	
	buttons = [button_food, button_fabric, button_rum, button_leather, button_iron, button_livestock]

func show_win_screen(enemyShip):
	get_tree().paused = true
	
	show()
	
	gold = enemyShip.gold
	
	for key in goods.keys():
		goods[key] = randi_range(1, 10)
	
	
	inventory_text.text = "Remaining inventory room: " + str(Player.get_inventory_space())
	loot_gold_text.text = "Gold: " + str(gold) + "\n"
	button_food.text = "Food: " + str(goods[EconomyGlobals.GoodType.FOOD]) + "\n"
	button_fabric.text = "Fabric: " + str(goods[EconomyGlobals.GoodType.FABRIC]) + "\n"
	button_rum.text = "Rum: " + str(goods[EconomyGlobals.GoodType.RUM]) + "\n"
	button_leather.text = "Leather: " + str(goods[EconomyGlobals.GoodType.LEATHER]) + "\n"
	button_iron.text = "Iron: " + str(goods[EconomyGlobals.GoodType.IRON]) + "\n"
	button_livestock.text = "Livestock: " + str(goods[EconomyGlobals.GoodType.LIVESTOCK]) + "\n"
	
	Player.add_gold(gold)


func _on_button_leave_pressed():
	#pass # Replace with function body.
	button_food.disabled = false
	button_fabric.disabled = false
	button_rum.disabled = false
	button_leather.disabled = false
	button_iron.disabled = false
	button_livestock.disabled = false
	get_tree().paused = false
	hide()


func _on_button_good_pressed(good_type):
	var good_change = min(goods[good_type], Player.get_inventory_space())
	Player.inventory[good_type] += good_change
	Player.inv_occupied += good_change
	buttons[good_type].disabled = true
	inventory_text.text = "Remaining inventory room: " + str(Player.get_inventory_space())
	if Player.get_inventory_space() <= 0:
		disable_buttons()


func disable_buttons():
	for button in buttons:
			button.disabled = true
