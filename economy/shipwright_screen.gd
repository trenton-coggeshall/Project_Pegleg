extends Control

@onready var home_screen = $"../HomeScreen"

@onready var upgrade_1_buttons = [$OptionContainer/HBoxContainer/VBoxContainer/Upgrade1Button1,
								  $OptionContainer/HBoxContainer/VBoxContainer/Upgrade1Button2,
								  $OptionContainer/HBoxContainer/VBoxContainer/Upgrade1Button3]

@onready var upgrade_2_buttons = [$OptionContainer/HBoxContainer/VBoxContainer2/Upgrade2Button1,
								  $OptionContainer/HBoxContainer/VBoxContainer2/Upgrade2Button2,
								  $OptionContainer/HBoxContainer/VBoxContainer2/Upgrade2Button3]

var upgrades_1 : Array
var upgrades_2 : Array

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
		
		upgrade_2_buttons[i].text = upgrade_type_2[upgrades_2[i]]["display_name"]
		upgrade_2_buttons[i].tooltip_text = upgrade_type_2[upgrades_2[i]]["details"]
	
	check_player_upgrades()
	
	show()


func _on_back_button_pressed():
	hide()
	home_screen.show()


func check_player_upgrades():
	var player_upgrades_1 = Player.upgrades[Player.current_port.upgrade_types[0]]
	var player_upgrades_2 = Player.upgrades[Player.current_port.upgrade_types[1]]
	
	for i in len(upgrades_1):
		upgrade_1_buttons[i].disabled = player_upgrades_1.has(upgrades_1[i]) or not UpgradeGlobals.check_prereqs(Player.current_port.upgrade_types[0], upgrades_1[i])
		upgrade_2_buttons[i].disabled = player_upgrades_2.has(upgrades_2[i]) or not UpgradeGlobals.check_prereqs(Player.current_port.upgrade_types[1], upgrades_2[i])


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
