extends Spatial


onready var target = owner.get_node("Player")

var default_rot = Vector2(-PI/6, 0)
var target_rot = default_rot

var is_following = true

func _ready():
	rotation = Vector3(default_rot.x, default_rot.y, 0)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		#toggle something
		#is_smooth = !is_smooth
		pass


func _physics_process(delta):
	
	rotation.y = lerp_angle(rotation.y, target_rot.y, 0.05)
	rotation.x = lerp_angle(rotation.x, target_rot.x, 0.05)
	
#	rotation.y = move_toward(rotation.y, target_rot.y, PI/200)
#	rotation.x = move_toward(rotation.x, target_rot.x, PI/200)
	
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
