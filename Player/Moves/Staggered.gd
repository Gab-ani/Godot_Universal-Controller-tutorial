extends Move


const ANIMATION_END = 0.9833


func default_lifecycle(input : InputPackage):
	if works_longer_than(ANIMATION_END):
		return best_input_that_can_be_paid(input)
	return "okay"


#func update(input : InputPackage, delta : float):
	# do gravity staff
	# I know it just stands in the air, but to be just staggered-and-falling is boring,
	# ideally I wanted stagger from midair to have animation of uncontrolled falling into a pit and laying
	# on the ground, but haven't done it yet 
