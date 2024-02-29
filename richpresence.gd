extends Node

func _ready():
	DiscordSDK.app_id = 1205246280536952862 # Application ID
	DiscordSDK.details = "Sailing the high seas"
	DiscordSDK.state = "Money: " + str(Player.gold) + "g"
	
	DiscordSDK.large_image = "pirateicon" # Image key from "Art Assets"
	DiscordSDK.large_image_text = "Project Pegleg"
	DiscordSDK.small_image = "compass" # Image key from "Art Assets"
	DiscordSDK.small_image_text = "Lost at sea"

	DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# DiscordSDK.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"

	DiscordSDK.refresh() # Always refresh after changing the values!
