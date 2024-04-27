extends Node
class_name Combo


@onready var move : Move 
@export var triggered_move : String


func is_triggered(_input : InputPackage) -> bool:
	return false


# As basic combos have one plain function, which is always called in some Move's check_relevance
# function at the first string, it seems like we are over-abstracting a bit. Why don't we
# just put a code that decides if slash_1 progresses into slash_2 in slash_1 directly and
# call this functional "slash_1 locally"?

# Well, for such a basic example as chaining consecutive strikes into series, it can be true. 
# But the purpose of Combos is to further divide the Move's transition logic to enhance scalability.
# Many different factors can regulate Move's transition, I can imagine adrenaline level,
# fatique level, mana/stamina statuses, some unique items in the inventory, some finishing
# limbs-choping with a random chance of procking, enemies type, 
# different buffs, all this can influent our states flow... 

# Imagine modifying it all every time adding another elif into Move's check_transition.
# With combos, you-from-the-future can work on a project for a year and then suddenly decide
# that you need some randomised heads choping finishers.
# Will it ever be easier than just creating a combo with 7-strings logic and droping it on your Moves?
# And we even query our combos work with get_children() collection from a Move, so there is
# a fantom combo priority system being powered just by Combo nodes order in the editor. Sick!

# The Move code is a super-basic action logic, think, 
# "what your game was with a linear inputs where every action has a hotkey and no secondary inputs", 
# the plainest, flatest implementation of your state machine without complex conditions.

# The Combos code is a module for creating additional layers of conditional transitions that can be
# added, mixed, copied and deleted without your base check_relevance function changing a symbol.





