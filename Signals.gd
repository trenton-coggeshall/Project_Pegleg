extends Node

#+------------+
#| UI Signals |
#+------------+

signal hide_ui
signal show_ui

signal speed_changed(value)
signal gold_changed(value)
signal username_changed(value)

signal player_damaged(value)
signal player_healed(value)
signal player_full_healed()
signal player_left_port()

signal start_combat(enemyShip)
signal end_combat()

signal show_end_screen_win()
