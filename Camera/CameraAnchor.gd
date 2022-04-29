extends Spatial


onready var target = owner.get_node("Player")

var default_rot = Vector2(-PI/6, 0)
var target_rot = default_rot
var unfiltered_rot = default_rot
var last_rot = default_rot

var rot_rate = 0.015
var rot_phase = 1

var is_following = true

func _ready():
	rotation = Vector3(default_rot.x, default_rot.y, 0)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		#toggle something
		#is_smooth = !is_smooth
		pass


func _physics_process(delta):
	
	if rot_phase < 1:
		rot_phase += rot_rate
		rot_phase = min(rot_phase, 1)
	
	rotation.y = lerp_angle(last_rot.y, target_rot.y, ease(rot_phase, -2))
	rotation.x = lerp_angle(last_rot.x, target_rot.x, ease(rot_phase, -2))
	
	transform = transform.orthonormalized()
	
	var clampRegion = 20
	if is_following:
			set_translation(Vector3(
				clamp(target.get_translation().x, -clampRegion, clampRegion),
				get_translation().y,
				clamp(target.get_translation().z, -clampRegion, clampRegion)
			))
			if target.is_on_floor():
				set_translation(Vector3(
					get_translation().x,
					lerp(get_translation().y, target.get_translation().y, 0.15),
					get_translation().z
				))
	else:
		transform.origin.y = target.transform.origin.y

func cam_angle(target_x = default_rot, target_y = default_rot):
	rot_phase = 0
	last_rot = Vector2(rotation.x, rotation.y)
	target_rot = Vector2(target_x, target_y)
