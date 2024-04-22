extends Combo

@onready var slash_2 = $".." as Slash2

const PANIC_CLICK_PREVENTION = 0.1

func _ready():
	triggered_move = "slash_3"


func is_triggered(input : InputPackage):
	if input.actions.has("slash_1") and slash_2.works_longer_than(PANIC_CLICK_PREVENTION):
		return true
	return false
