extends Control

@onready var crew_text = $CrewText
@onready var hire_count_text = $HireCountText
@onready var tavern_screen = $"../TavernScreen"
@onready var crew_slider = $CrewSlider
@onready var cost_text = $OptionContainer/CostText
@onready var hire_button = $OptionContainer/HireButton

var cost : int
var crew_count : int

func show_crew_screen():
	cost = Player.current_port.crew_cost
	crew_count = Player.current_port.hireable_crew
	
	crew_slider.max_value = crew_count
	crew_slider.value = min(crew_slider.max_value, Player.stats['crew_max'] - Player.crew_count)
	crew_check()
	show()


func crew_check():
	if crew_count > 0:
		crew_text.text = "There are " + str(crew_count) + " men willing to join your crew for " + str(cost) + " a head."
	else:
		crew_text.text = "No one is looking for work right now."
	
	crew_text.text += "\n\nYou currently have a crew of " + str(Player.crew_count) + " out of a possible " + str(Player.stats['crew_max']) + "."


func _on_crew_slider_value_changed(value):
	hire_count_text.text = str(value)
	cost_text.text = "Cost: " + str(value * cost) + "g"
	
	if value * cost > Player.gold or value > Player.stats['crew_max'] - Player.crew_count:
		hire_button.disabled = true
	else:
		hire_button.disabled = false


func _on_back_button_pressed():
	hide()
	tavern_screen.show()


func _on_hire_button_pressed():
	var count = crew_slider.value
	Player.add_crew(count)
	Player.remove_gold(count * cost)
	crew_count -= count
	Player.current_port.hireable_crew -= count
	crew_slider.max_value = crew_count
	if count > crew_slider.max_value:
		crew_slider.value = crew_slider.max_value
	crew_check()
