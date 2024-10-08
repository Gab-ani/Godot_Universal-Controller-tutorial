@tool
extends EditorScenePostImport

var bake_root : bool = true
var root_z_coordinate = -0.062

func _post_import(scene):
	var player = find_animation_player(scene)
	var skeleton = find_skeleton(scene)
	print("animations found: " + str(player.get_animation_list()))
	save_torso_animations(player, skeleton)
	save_legs_animations(player, skeleton)
	return scene


func find_animation_player(scene : Node) -> AnimationPlayer:
	return scene.get_node("AnimationPlayer") 

func find_skeleton(scene : Node) -> Skeleton3D:
	return scene.get_node("Armature/GeneralSkeleton") 


func save_torso_animations(player : AnimationPlayer, skeleton : Skeleton3D):
	#print("saving torso tracks")
	var torso_indeсes = get_torso_bones_indeces(skeleton)
	for animation_name in player.get_animation_list():
		if not idiot_proof(animation_name):
			continue
		var animation = player.get_animation(animation_name) as Animation
		var new_animation : Animation = Animation.new()
		new_animation.length = animation.length
		#print(animation_name + ":")
		for track in animation.get_track_count():
			var path : String = animation.track_get_path(track)
			# these are secondary rig tracks we used to animate in blender, they can be omitted
			if path.contains("Ctrl_") or path.contains("_IK_") or path.contains("_FK_"): 
				continue
			#print(animation.track_get_path(track))
			var bone_name = path.replace("%GeneralSkeleton:", "")
			var bone_index = skeleton.find_bone(bone_name)
			if torso_indeсes.has(bone_index):
				animation.copy_track(track, new_animation)
		ResourceSaver.save(new_animation, "res://Assets/Ready Animations/mixamo_torso_animations/" + animation_name + "_torso.res")


func save_legs_animations(player : AnimationPlayer, skeleton : Skeleton3D):
	print("saving legs tracks")
	var legs_indeсes = get_legs_bones_indeces(skeleton)
	for animation_name in player.get_animation_list():
		if not idiot_proof(animation_name):
			continue
		var animation = player.get_animation(animation_name) as Animation
		var new_animation : Animation = Animation.new()
		new_animation.length = animation.length
		#print(animation_name + ":")
		for track in animation.get_track_count():
			var path : String = animation.track_get_path(track)
			# these are secondary rig tracks we used to animate in blender, they can be omitted
			if path.contains("Ctrl_") or path.contains("_IK_"): 
				continue
			#print(animation.track_get_path(track))
			var bone_name = path.replace("%GeneralSkeleton:", "")
			var bone_index = skeleton.find_bone(bone_name)
			if legs_indeсes.has(bone_index):
				animation.copy_track(track, new_animation)
		ResourceSaver.save(new_animation, "res://Assets/Ready Animations/mixamo_legs_animations/" + animation_name + "_legs.res")


func idiot_proof(animation_name : String):
	return not (animation_name.contains("Armature") or animation_name.contains("Action") or animation_name.contains("Layer"))


func get_torso_bones_indeces(skeleton : Skeleton3D) -> Array:
	return get_hierarchy_indexes(skeleton, skeleton.find_bone("Spine"))


func get_legs_bones_indeces(skeleton : Skeleton3D) -> Array:
	var right_leg_indeces = get_hierarchy_indexes(skeleton, skeleton.find_bone("RightUpperLeg"))
	var left_leg_indeces = get_hierarchy_indexes(skeleton, skeleton.find_bone("LeftUpperLeg"))
	var result = [0] # Hips
	result.append_array(right_leg_indeces)
	result.append_array(left_leg_indeces)
	return result

# we can't have a static index range here, because mixamo skeletons can slightly change, some
# have additional head IK, some don't, some we animate with additional rig, some not etc.
# However, there is a constant structure: 
# Hips bone always is a parent to Spine, RightUpperLeg and LeftUpperLeg.
# So we can get the list of torso bones by calling this from 1.(Hips are bone № 0)
func get_hierarchy_indexes(skeleton : Skeleton3D, root_idx : int) -> Array:
	var indeсes = []
	for child_bone in skeleton.get_bone_children(root_idx):
		indeсes.append_array(get_hierarchy_indexes(skeleton, child_bone)) 
	indeсes.append(root_idx)
	indeсes.sort()
	if root_idx == 1:
		print(indeсes)
	return indeсes
