extends Move


func on_enter_state():
	player.add_to_group("parried_humanoid")


func on_exit_state():
	player.remove_from_group("parried_humanoid")
