extends AnimationPlayer


@export var root_position : Vector3
@export var transitions_to_queued : bool
@export var accepts_queueing : bool
@export var is_parryable : bool
@export var is_vulnerable : bool
@export var is_interruptable : bool
@export var is_grabable : bool
@export var right_hand_weapon_hurts : bool
@export var tracks_input_vector : bool


func get_boolean_value(animation : String, track_name : String, timecode : float) -> bool:
	var data = get_animation(animation)
	var track = data.find_track(track_name, Animation.TYPE_VALUE)
	return data.value_track_interpolate(track, timecode)
