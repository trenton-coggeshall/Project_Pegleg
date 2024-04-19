extends Control

@onready var home_screen = $"../HomeScreen"

@onready var upgrade_1_buttons = [$OptionContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade1Button1,
								  $OptionContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Upgrade1Button2,
								  $OptionContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Upgrade1Button3]

@onready var upgrade_1_prices = [$OptionContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade1Price1,
								 $OptionContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Upgrade1Price2,
								 $OptionContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Upgrade1Price3]

@onready var upgrade_2_buttons = [$OptionContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Upgrade2Button1,
								  $OptionContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/Upgrade2Button2,
								  $OptionContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/Upgrade2Button3]

@onready var upgrade_2_prices = [$OptionContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Upgrade2Price1,
								 $OptionContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/Upgrade2Price2,
								 $OptionContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/Upgrade2Price3]

@onready var repair_cost_label = $OptionContainer/RepairCost
@onready var repair_button = $OptionContainer/RepairButton

var upgrades_1 : Array
var upgrades_2 : Array
var repair_cost : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_shipwright_screen():
	var upgrade_type_1 = UpgradeGlobals.UPGRADE_LIST[Player.current_port.upgrade_types[0]]
	upgrades_1 = upgrade_type_1.keys()
	
	var upgrade_type_2 = UpgradeGlobals.UPGRADE_LIST[Player.current_port.upgrade_types[1]]
	upgrades_2 = upgrade_type_2.keys()
	
	for i in len(upgrade_1_buttons):
		upgrade_1_buttons[i].text = upgrade_type_1[upgrades_1[i]]["display_name"]
		upgrade_1_buttons[i].tooltip_text = upgrade_type_1[upgrades_1[i]]["details"]
		upgrade_1_prices[i].text = str(upgrade_type_1[upgrades_1[i]]["cost"]) + 'g'
		
		upgrade_2_buttons[i].text = upgrade_type_2[upgrades_2[i]]["display_name"]
		upgrade_2_buttons[i].tooltip_text = upgrade_type_2[upgrades_2[i]]["details"]
		upgrade_2_prices[i].text = str(upgrade_type_2[upgrades_2[i]]["cost"]) + 'g'
	
	check_player_upgrades()
	
	if Player.health < Player.max_health:
		repair_cost = Player.max_health - Player.health
		repair_cost_label.text = "Cost to repair: " + str(repair_cost) + "g"
		repair_button.disabled = false
	else:
		repair_cost_label.text = "Nothing wrong with her!"
		repair_button.disabled = true
	
	show()


func _on_back_button_pressed():
	hide()
	home_screen.show()


func check_player_upgrades():
	var player_upgrades_1 = Player.upgrades[Player.current_port.upgrade_types[0]]
	var player_upgrades_2 = Player.upgrades[Player.current_port.upgrade_types[1]]
	
	for i in len(upgrades_1):
		var disabled_1 = player_upgrades_1.has(upgrades_1[i]) or not UpgradeGlobals.check_prereqs(Player.current_port.upgrade_types[0], upgrades_1[i])
		var disabled_2 = player_upgrades_2.has(upgrades_2[i]) or not UpgradeGlobals.check_prereqs(Player.current_port.upgrade_types[1], upgrades_2[i])
		
		upgrade_1_buttons[i].disabled = disabled_1
		if disabled_1:
			upgrade_1_prices[i].modulate.a = 0.35
		else:
			upgrade_1_prices[i].modulate.a = 1
		
		upgrade_2_buttons[i].disabled = disabled_2
		if disabled_2:
			upgrade_2_prices[i].modulate.a = 0.35
		else:
			upgrade_2_prices[i].modulate.a = 1


func _on_upgrade_button_pressed(upgrade_type_num, upgrade_num):
	var upgrade_type = Player.current_port.upgrade_types[upgrade_type_num]
	var upgrade_list : Array
	
	if upgrade_type_num == 0:
		upgrade_list = upgrades_1
	else:
		upgrade_list = upgrades_2
	
	var upgrade = UpgradeGlobals.UPGRADE_LIST[upgrade_type][upgrade_list[upgrade_num]]
	
	if Player.gold < upgrade['cost']:
		print("not enough player gold")
		return
	
	Player.add_upgrade(upgrade_type, upgrade_list[upgrade_num])
	Player.gold -= upgrade['cost']
	check_player_upgrades()


func _on_repair_button_pressed():
	if Player.gold < repair_cost:
		print("Not enough gold to repair")
		return
	
	Player.remove_gold(repair_cost)
	Player.health = Player.max_health
	repair_cost = 0
	repair_cost_label.text = "She's all patched up!"
	repair_button.disabled = true
