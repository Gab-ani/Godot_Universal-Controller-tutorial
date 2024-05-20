extends Combo



func is_triggered(input : InputPackage) -> bool:
	# if input.actions.has( current weapon light attack move code ) in future for scalability
	if input.actions.has("longsword_1") and have_target_for_ripost():
		return true
	return false


# extremely lazy implementation, for nicer results, use conuses or other 
# "area of ripost grabbing", also the target defined by this algo
# needs to be notified it is being ripost-grabbed, probably via some Move.react_on_ripost(). 
# But the workflow is correct, nothing conceptual will change, just better animations etc. 
func have_target_for_ripost() -> bool:
	var parried_victims = get_tree().get_nodes_in_group("parried_humanoid")
	for humanoid in parried_victims:
		if humanoid.global_position.distance_to(move.humanoid.global_position) < 2:
			return true
	return false
