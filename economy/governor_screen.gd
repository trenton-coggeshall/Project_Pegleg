extends Control

@onready var home_screen = $"../HomeScreen"
@onready var forgive_text = $ForgiveText
@onready var cost_text = $CostText
@onready var reputation_button = $OptionContainer/ReputationButton


var forgive_cost = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show_governor_screen():
	if FactionGlobals.reputation[Player.current_port.faction] < 0:
		forgive_text.text = 'You scoundrel! I will forgive you... For a price.'
		forgive_cost = abs(FactionGlobals.reputation[Player.current_port.faction]) * 50
		cost_text.text = str(forgive_cost) + 'g'
		reputation_button.disabled = Player.gold < forgive_cost
	else:
		forgive_text.text = 'How can I help you?'
		cost_text.text = ''
		reputation_button.disabled = true
	show()


func _on_back_button_pressed():
	hide()
	home_screen.show()


func _on_reputation_button_pressed():
	reputation_button.disabled = true
	Player.remove_gold(forgive_cost)
	Player.current_port.gold += forgive_cost
	cost_text.text = ''
	forgive_text.text = 'Be careful. I may not be so forgiving next time!'
	FactionGlobals.reputation[Player.current_port.faction] = 0
