extends Control

@onready var port_screen = $"../port_screen"
@onready var port_button = $OptionContainer/PortButton
@onready var combat_scene = $"../../CombatScene"

var ship_buttons : Array
var ship_nodes : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	#Disgusting, fix this later
	ship_buttons = $OptionContainer.get_children()
	ship_buttons.pop_front()
	ship_buttons.pop_back()


func _process(_delta):
	if Input.is_action_just_pressed('cancel') and visible:
		hide_interaction_screen()


func show_interaction_screen(ships, near_port):
	ship_nodes = ships
	
	if near_port:
		port_button.show()
	
	for i in len(ships):
		ship_buttons[i].text = 'Fight ' + ships[i].get_parent().get_parent().name
		ship_buttons[i].show()
	
	show()
	get_tree().paused = true


func hide_interaction_screen():
	port_button.hide()
	for button in ship_buttons:
		button.hide()
	
	hide()
	get_tree().paused = false


func _on_port_button_pressed():
	hide_interaction_screen()
	port_screen.show_port_screen()


func _on_ship_button_pressed(extra_arg_0):
	hide_interaction_screen()
	combat_scene.start_combat(ship_nodes[extra_arg_0].get_parent())


func _on_button_pressed():
	hide_interaction_screen()
