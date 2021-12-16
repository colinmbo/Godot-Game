extends Spatial


onready var target = owner.get_node("Player")

var target_rotation = 0
var prev_angle = 0
var angle_change_amt = 0
var changing_angle = false

var is_smooth = false
var is_following = true

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		is_smooth = !is_smooth


func _physics_process(delta):
	
	#rotation_degrees.y = rad2deg(lerp_angle(deg2rad(rotation_degrees.y), deg2rad(target_rotation), 0.1))
	
	if changing_angle:
		angle_change_amt += 0.005
		rotation_degrees.y = rad2deg(lerp_angle(deg2rad(prev_angle), deg2rad(target_rotation), ease(angle_change_amt,-2.5)))
		if angle_change_amt >= 1:
			angle_change_amt = 0
			changing_angle = false
	
	if is_following:
		if is_smooth:
			set_translation(Vector3(
				lerp(get_translation().x, target.get_translation().x, 0.025),
				get_translation().y,
				lerp(get_translation().z, target.get_translation().z, 0.025)
			))
			if target.is_on_floor():
				set_translation(Vector3(
					get_translation().x,
					lerp(get_translation().y, target.get_translation().y, 0.025),
					get_translation().z
				))
		else:
			set_translation(Vector3(
				clamp(target.get_translation().x, -15, 15),
				get_translation().y,
				clamp(target.get_translation().z, -15, 15)
			))
			if target.is_on_floor():
				set_translation(Vector3(
					get_translation().x,
					lerp(get_translation().y, target.get_translation().y, 0.15),
					get_translation().z
				))
	else:
		var newTarget = owner.get_node("NPC1")
		var pan_speed = 0.1
		if abs(get_translation().x - newTarget.get_translation().x) > pan_speed:
			set_translation(Vector3(get_translation().x-sign(get_translation().x-newTarget.get_translation().x)*pan_speed, get_translation().y, get_translation().z))
		if abs(get_translation().y - newTarget.get_translation().y) > pan_speed:
			set_translation(Vector3(get_translation().x, get_translation().y-sign(get_translation().y-newTarget.get_translation().y)*pan_speed, get_translation().z))
		if abs(get_translation().z - newTarget.get_translation().z) > pan_speed:
			set_translation(Vector3(get_translation().x, get_translation().y, get_translation().z-sign(get_translation().z-newTarget.get_translation().z)*pan_speed))

func change_angle(new_angle):
	changing_angle = true
	prev_angle = rotation_degrees.y
	target_rotation = new_angle
