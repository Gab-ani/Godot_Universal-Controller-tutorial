extends Node


func get_default_reactions_dictionary() -> Dictionary:
	return {
		"death" : $Death,
		"stagger" : $Staggered,
		"parried" : $Parried
	}
