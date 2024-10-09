extends Node
class_name MovesDataRepository

@export var move_database : AnimationPlayer


func get_root_delta_pos(animation : String, progress : float, delta : float) -> Vector3:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
	if data.track_get_key_count(track) == 0:
		return Vector3.ZERO
	var previous_pos = data.value_track_interpolate(track, progress - delta)
	var current_pos = data.value_track_interpolate(track, progress)
	var delta_pos = current_pos - previous_pos
	return delta_pos


func get_transitions_to_queued(animation : String, timecode : float) -> bool:
	return move_database.get_boolean_value(animation, "MoveDatabase:transitions_to_queued", timecode) 

func get_accepts_queueing(animation : String, timecode : float) -> bool:
	return move_database.get_boolean_value(animation, "MoveDatabase:accepts_queueing", timecode) 

func get_vulnerable(animation : String, timecode : float) -> bool:
	return move_database.get_boolean_value(animation, "MoveDatabase:is_vulnerable", timecode) 

func get_interruptable(animation : String, timecode : float) -> bool:
	return move_database.get_boolean_value(animation, "MoveDatabase:is_interruptable", timecode) 

func get_parryable(animation : String, timecode : float) -> bool:
	return move_database.get_boolean_value(animation, "MoveDatabase:is_parryable", timecode)

func get_duration(animation : String) -> float:
	return move_database.get_animation(animation).length

func get_right_weapon_hurts(animation : String, timecode : float) -> bool:
	return move_database.get_boolean_value(animation, "MoveDatabase:right_hand_weapon_hurts", timecode)

func tracks_input_vector(animation : String, timecode : float) -> bool:
	return move_database.get_boolean_value(animation, "MoveDatabase:tracks_input_vector", timecode)
