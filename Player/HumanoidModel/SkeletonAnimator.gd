extends AnimationPlayer


func _ready():
	DEV_nail_z_coordinate()
	configure_blending_times()


func configure_blending_times():
	set_blend_time("idle_longsword", "run", 0.3)
	set_blend_time("landing_run", "run", 0.5)
	set_blend_time("jump_sprint", "midair", 0.5)
	set_blend_time("landing_run", "sprint", 0.3)
	set_blend_time("landing_sprint", "run", 0.3)
	set_blend_time("idle", "slash_1", 0.5)
	set_blend_time("idle", "parry", 0.3)
	set_blend_time("parry", "idle", 0.3)
	set_blend_time("longsword_1_rooted", "idle_longsword", 0.8)
	set_blend_time("longsword_1_rooted", "run", 0.3)
	set_blend_time("longsword_1_rooted", "sprint", 0.3)

# DEVELOPMENT LAYER FUNCTIONAL, IT DOES MODIFY ASSETS, UNCOMMENT IF YOU KNOW WHAT YOU ARE DOING
func DEV_nail_z_coordinate():
	var animation = get_animation("slash_3_rooted") as Animation
	var hips_track = animation.find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)
	print(animation.track_get_key_count(hips_track))
	for i : int in animation.track_get_key_count(hips_track):
		var position = animation.track_get_key_value(hips_track, i)
		var time = animation.track_get_key_time(hips_track, i)
		print(str(position) + " at " + str(time))
		var position_without_z = position
		position_without_z.z = 0.073
		animation.track_set_key_value(hips_track, i, position_without_z)
		ResourceSaver.save(animation, "res://Assets/Ready Animations/slash_3_rooted.res")
		
