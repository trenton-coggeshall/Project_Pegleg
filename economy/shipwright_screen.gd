extends Control

@onready var home_screen = $"../HomeScreen"
@onready var upgrade_1_button_1 = $OptionContainer/HBoxContainer/VBoxContainer/Upgrade1Button1
@onready var upgrade_1_button_2 = $OptionContainer/HBoxContainer/VBoxContainer/Upgrade1Button2
@onready var upgrade_1_button_3 = $OptionContainer/HBoxContainer/VBoxContainer/Upgrade1Button3
@onready var upgrade_2_button_1 = $OptionContainer/HBoxContainer/VBoxContainer2/Upgrade2Button1
@onready var upgrade_2_button_2 = $OptionContainer/HBoxContainer/VBoxContainer2/Upgrade2Button2
@onready var upgrade_2_button_3 = $OptionContainer/HBoxContainer/VBoxContainer2/Upgrade2Button3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_shipwright_screen():
	var upgrade_type_1 = UpgradeGlobals.UPGRADE_LIST[Player.current_port.upgrade_types[0]]
	var upgrades_1 = upgrade_type_1.keys()
	
	upgrade_1_button_1.text = upgrade_type_1[upgrades_1[0]]["display_name"]
	upgrade_1_button_2.text = upgrade_type_1[upgrades_1[1]]["display_name"]
	upgrade_1_button_3.text = upgrade_type_1[upgrades_1[2]]["display_name"]
	
	var upgrade_type_2 = UpgradeGlobals.UPGRADE_LIST[Player.current_port.upgrade_types[1]]
	var upgrades_2 = upgrade_type_2.keys()
	
	upgrade_2_button_1.text = upgrade_type_2[upgrades_2[0]]["display_name"]
	upgrade_2_button_2.text = upgrade_type_2[upgrades_2[1]]["display_name"]
	upgrade_2_button_3.text = upgrade_type_2[upgrades_2[2]]["display_name"]
	
	
	show()


func _on_back_button_pressed():
	hide()
	home_screen.show()
