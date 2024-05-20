extends Node
class_name MovesDataRepository

@onready var move_database = $MoveDatabase



func get_root_delta_pos(animation : String, progress : float, delta : float) -> Vector3:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
	var previous_pos = data.value_track_interpolate(track, progress - delta)
	var current_pos = data.value_track_interpolate(track, progress)
	var delta_pos = current_pos - previous_pos
	return delta_pos


func get_transitions_to_queued(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:transitions_to_queued", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_accepts_queueing(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:accepts_queueing", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_vulnerable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_vulnerable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_interruptable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_interruptable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_parryable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_parryable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)

func get_duration(animation : String) -> float:
	return move_database.get_animation(animation).length

func get_right_weapon_hurts(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:right_hand_weapon_hurts", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)
