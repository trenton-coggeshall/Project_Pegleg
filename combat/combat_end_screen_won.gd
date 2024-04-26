extends Control

@onready var victory_text = $victory_text
@onready var lost_text = $lost_text
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
@onready var player = $"../Player"

var won = true
var rng = RandomNumberGenerator.new()

var gold = 0
var food = 0
var fabric = 0
var rum = 0
var leather = 0
var iron = 0
var livestock = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	Signals.show_end_screen_win.connect(show_win_screen)
	
	

func show_win_screen():
	
	print("SHOW")
	show()
	
	rng.randomize()
	
	gold = rng.randi_range(300, 1000)
	food = rng.randi_range(3, 10)
	fabric = rng.randi_range(1, 10)
	rum = rng.randi_range(1, 10)
	leather = rng.randi_range(1, 10)
	iron = rng.randi_range(1, 10)
	livestock = rng.randi_range(1, 10)
	
	inventory_text.text += str(Player.inv_limit - Player.inv_occupied + Player.modifiers['cargo'])
	loot_gold_text.text += "Gold: " + str(gold) + "\n"
	button_food.text += "Food: " + str(food) + "\n"
	button_fabric.text += "Fabric: " + str(fabric) + "\n"
	button_rum.text += "Rum: " + str(rum) + "\n"
	button_leather.text += "Leather: " + str(leather) + "\n"
	button_iron.text += "Iron: " + str(iron) + "\n"
	button_livestock.text += "Livestock: " + str(livestock) + "\n"
	
	Player.add_gold(gold)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_leave_pressed():
	#pass # Replace with function body.
	button_food.disabled = false
	button_fabric.disabled = false
	button_rum.disabled = false
	button_leather.disabled = false
	button_iron.disabled = false
	button_livestock.disabled = false
	hide()


func _on_button_food_pressed():
	#pass # Replace with function body.
	if(Player.inv_occupied + food < Player.inv_limit + Player.modifiers['cargo']):
		button_food.disabled = true
		Player.inventory[EconomyGlobals.GoodType.FOOD] += food
		Player.inv_occupied += food
		inventory_text.text = "Remaining inventory room: " + str(Player.inv_limit - Player.inv_occupied + Player.modifiers['cargo'])


func _on_button_fabric_pressed():
	#pass # Replace with function body.
	if(Player.inv_occupied + fabric < Player.inv_limit + Player.modifiers['cargo']):
		button_fabric.disabled = true
		Player.inventory[EconomyGlobals.GoodType.FABRIC] += fabric
		Player.inv_occupied += fabric
		inventory_text.text = "Remaining inventory room: " + str(Player.inv_limit - Player.inv_occupied + Player.modifiers['cargo'])


func _on_button_rum_pressed():
	#pass # Replace with function body.
	if(Player.inv_occupied + rum < Player.inv_limit + Player.modifiers['cargo']):
		button_rum.disabled = true
		Player.inventory[EconomyGlobals.GoodType.RUM] += rum
		Player.inv_occupied += rum
		inventory_text.text = "Remaining inventory room: " + str(Player.inv_limit - Player.inv_occupied + Player.modifiers['cargo'])



func _on_button_leather_pressed():
	#pass # Replace with function body.
	if(Player.inv_occupied + leather < Player.inv_limit + Player.modifiers['cargo']):
		button_leather.disabled = true
		Player.inventory[EconomyGlobals.GoodType.LEATHER] += leather
		Player.inv_occupied += leather
		inventory_text.text = "Remaining inventory room: " + str(Player.inv_limit - Player.inv_occupied + Player.modifiers['cargo'])


func _on_button_iron_pressed():
	#pass # Replace with function body.
	if(Player.inv_occupied + iron < Player.inv_limit + Player.modifiers['cargo']):
		button_iron.disabled = true
		Player.inventory[EconomyGlobals.GoodType.IRON] += iron
		Player.inv_occupied += iron
		inventory_text.text = "Remaining inventory room: " + str(Player.inv_limit - Player.inv_occupied + Player.modifiers['cargo'])
		

func _on_button_livestock_pressed():
	#pass # Replace with function body.
	if(Player.inv_occupied + livestock < Player.inv_limit + Player.modifiers['cargo']):
		button_livestock.disabled = true
		Player.inventory[EconomyGlobals.GoodType.LIVESTOCK] += livestock
		Player.inv_occupied += livestock
		inventory_text.text = "Remaining inventory room: " + str(Player.inv_limit - Player.inv_occupied + Player.modifiers['cargo'])
