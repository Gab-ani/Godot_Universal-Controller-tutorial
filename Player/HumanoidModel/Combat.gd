extends Node
class_name HumanoidCombat


@onready var model = $".." as PlayerModel

static var inputs_priority : Dictionary = {
	"light_attack_pressed" : 1,
	"heavy_attack_pressed" : 2,
}


func translate_combat_actions(new_input : InputPackage) -> InputPackage:
	if not new_input.combat_actions.is_empty():
		new_input.combat_actions.sort_custom(combat_action_priority_sort)
		var best_input_action : String = new_input.combat_actions[0]
		var translated_into_move_name : String = model.active_weapon.basic_attacks[best_input_action]
		new_input.actions.append(translated_into_move_name)
	return new_input


static func combat_action_priority_sort(a : String, b : String):
	if inputs_priority[a] > inputs_priority[b]:
		return true
	else:
		return false
