extends Node

#+------------+
#| UI Signals |
#+------------+

signal hide_ui
signal show_ui

signal speed_changed(value)
signal gold_changed(value)
signal username_changed(value)

signal player_damaged(value, crew_loss)
signal player_healed(value)
signal player_set_health(value)
signal player_full_healed()
signal player_crew_gained()
signal player_update_max_health()
signal player_update_max_crew()
signal player_left_port()
signal player_ship_changed()
signal player_died()

signal updateReloadTimer(value)
signal hideReloadTimer()
signal showReloadTimer()

signal show_end_screen_win(enemyShip)
signal show_end_screen_lose()

signal start_combat(enemyShip)
signal end_combat()
