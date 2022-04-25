extends Camera


var offset := Vector2.ZERO
var shaking = false
var shake_magnitude = 0
var shake_decay = 0

var hitlagging = false
var lag_duration = 0


func _ready():
	# 36 is the game resolution width times the sprite pixel size (0.1)
	# 18 is half that
	# set_fov(2*rad2deg(atan(18/get_translation().z)))
	set_fov(2*rad2deg(atan(18/get_translation().z)))
	
func _process(delta):
	
	#Keep for debugging only
	if Input.is_action_pressed("modifier"):
		if Input.is_action_pressed("ui_left"):
			translate(Vector3(0,0,0.4))
		if Input.is_action_pressed("ui_right"):
			translate(Vector3(0,0,-0.4))
		if Input.is_action_pressed("ui_up"):
			get_parent().rotate_x(0.001)
		if Input.is_action_pressed("ui_down"):
			get_parent().rotate_x(-0.001)
		if Input.is_action_pressed("turn_right"):
			get_parent().rotate_y(0.005)
		if Input.is_action_pressed("turn_left"):
			get_parent().rotate_y(-0.005)
	
	# 36 is the game resolution width times the sprite pixel size (0.1)
	# 18 is half that
	if Input.is_action_pressed("interact"):
		set_fov(2*rad2deg(atan(18/get_translation().z)))
	
	if get_fov() < (2*rad2deg(atan(18/get_translation().z))):
		set_fov(2*rad2deg(atan(18/get_translation().z)))
	
	if shaking:
		if shake_magnitude <= 0:
			shaking = false
			shake_magnitude = 0
			shake_decay = 0
			offset = Vector2.ZERO
		else:
			offset.x = rand_range(-shake_magnitude, shake_magnitude)
			offset.y = rand_range(-shake_magnitude, shake_magnitude)
			shake_magnitude -= shake_decay
	
	if hitlagging:
		if get_tree().paused == false:
			get_tree().paused = true
			
		if lag_duration < 0:
			hitlagging = false
			lag_duration = 0
			get_tree().paused = false
		else:
			lag_duration -= 1	
	
	# Create offset for screenshake
	transform.origin.x = offset.x + 0.05
	transform.origin.y = offset.y


func hitlag(dur):
	hitlagging = true
	lag_duration = dur


func screenshake(magnitude, decay):
	shaking = true
	shake_magnitude = magnitude
	shake_decay = decay
