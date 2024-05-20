extends Move


func on_enter_state():
	humanoid.add_to_group("parried_humanoid")


func on_exit_state():
	humanoid.remove_from_group("parried_humanoid")
