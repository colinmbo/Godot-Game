extends Spatial


onready var target = owner.get_node("Player")

var is_smooth = false
var is_following = true

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		is_smooth = !is_smooth


func _physics_process(delta):
	
	var clampRegion = 30
	if is_following:
		if is_smooth:
			set_translation(Vector3(
				lerp(get_translation().x, target.get_translation().x, 0.08),
				get_translation().y,
				lerp(get_translation().z, target.get_translation().z, 0.08)
			))
			if target.is_on_floor():
				set_translation(Vector3(
					get_translation().x,
					lerp(get_translation().y, target.get_translation().y, 0.025),
					get_translation().z
				))
		else:
			set_translation(Vector3(
				clamp(target.get_translation().x, -clampRegion, clampRegion),
				get_translation().y,
				clamp(target.get_translation().z, -clampRegion, clampRegion)
			))
			if target.is_on_floor():
				set_translation(Vector3(
					get_translation().x,
					lerp(get_translation().y, target.get_translation().y+1.0, 0.15),
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



