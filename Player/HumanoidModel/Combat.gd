extends Node
class_name HumanoidCombat

@onready var model = $".." as PlayerModel

var events_buffer : Array[String] = ["falling"]

static var inputs_priority : Dictionary = {
	"light_attack_pressed" : 1,
	"heavy_attack_pressed" : 2,
}


func contextualize(new_input : InputPackage) -> InputPackage:
	translate_inputs(new_input)
	new_input.triggered_reactions.append_array(events_buffer)
	return new_input




func translate_inputs(input : InputPackage):
	if not input.combat_actions.is_empty():
		input.combat_actions.sort_custom(combat_action_priority_sort)
		var best_input_action : String = input.combat_actions[0]
		var translated_into_move_name : String = model.active_weapon.basic_attacks[best_input_action]
		input.actions.append(translated_into_move_name)


static func combat_action_priority_sort(a : String, b : String):
	if inputs_priority[a] > inputs_priority[b]:
		return true
	else:
		return false


