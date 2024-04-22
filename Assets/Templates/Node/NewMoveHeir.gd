extends Move
class_name NewMove
# Step 1: redefine your class_name

# Step 2: redefine your overriden parameters 
func _ready():
	animation = "dasdasd"
	move_name = "dasdasdas"

# Step 3: navigate to Model and add a new state to moves dictionary
# Step 4: navigate to base Move and add this new state to priority dictionary


# Step 5: implement a check_relevance function to manage transitions, return action name or "okay"
func check_relevance(input : InputPackage):
	pass


# Step 6: implement an update function
func update(input : InputPackage, delta : float):
	pass

# Step 7: use these bros if needed
func on_enter_state():
	pass

func on_exit_state():
	pass

# Step 8: delete annoying comments telling you what to do
