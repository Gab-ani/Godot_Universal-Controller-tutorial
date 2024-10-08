extends RayCast3D

@export var root_attachment : BoneAttachment3D

@onready var csg_sphere_3d_2 = $CSGSphere3D2

func _process(_delta):
	#print(root_attachment.global_position)
	global_position = root_attachment.global_position
	csg_sphere_3d_2.global_position = get_collision_point()
