extends Combo
class_name ConsecutiveAttack

@export var primary_input : String

func is_triggered(input : InputPackage):
	if input.actions.has(primary_input):
		return true
	return false

