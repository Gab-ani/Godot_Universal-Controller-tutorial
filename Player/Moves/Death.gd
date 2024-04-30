extends Move

# Step 3: navigate to Model and add a new state to moves dictionary
# Step 4: navigate to base Move and add this new state to priority dictionary

const ANIMATION_END : float = 3


func default_lifecycle(_input : InputPackage):
	if works_longer_than(ANIMATION_END):
		return "idle"
	return "okay"


func update(_input : InputPackage, _delta ):
	pass


func on_enter_state():
	pass

func on_exit_state():
	resources.gain_health(987651468)

