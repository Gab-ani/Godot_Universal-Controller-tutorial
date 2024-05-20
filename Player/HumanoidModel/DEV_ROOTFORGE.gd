extends Node

@onready var skeleton_animator = $"../SkeletonAnimator"
@onready var move_database = $"../States/MovesData/MoveDatabase"
@onready var model = $".."

func _ready():
	#DEV_nail_z_coordinate("longsword_2_1h", "longsword_2_params", -0.062)
	pass

#DEVELOPMENT LEAYER FUNCTIONAL, IT DOES MODIFY ASSETS, UNCOMMENT IF YOU KNOW WHAT YOU ARE DOING
#AND DID BACKUPS
#func DEV_nail_z_coordinate(animation_name : String, into_backend_animation : String, value : float):
	#if not model.is_enemy:
		#var animat ion = skeleton_animator.get_animation(animation_name) as Animation
		#var backend_animation = move_database.get_animation(into_backend_animation) as Animation
		#var backend_track = backend_animation.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
		#var hips_track = animation.find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)
		#print(animation.track_get_key_count(hips_track))
		#for i : int in animation.track_get_key_count(hips_track):
			#var position = animation.track_get_key_value(hips_track, i)
			#var time = animation.track_get_key_time(hips_track, i)
			#backend_animat ion.track_insert_key(backend_track, time, position)
			#print(str(position) + " at " + str(time))
			#var position_without_z = position
			#position_without_z.z = value
			#animation.track_set_key_value(hips_track, i, position_without_z)
		#ResourceSaver.save(animation, "res://Assets/Ready Animations/" + anima tion_name + "_Z_PROJECTED.res")
		#ResourceSaver.save(backend_animation, "res://Player/Moves/BackendAnimations/" + into_backend_animation + "_WITH_ROOT.res")
