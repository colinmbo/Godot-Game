extends Camera


var offset := Vector2.ZERO
var shaking = false
var shake_magnitude = 0
var shake_decay = 0


func _ready():
	# 32 is the game resolution width times the sprite pixel size (0.1)
	# 16 is half that
	set_fov(2*rad2deg(atan(18/get_translation().z)))


func _process(delta):
	
	#Keep for debugging only
	if Input.is_action_pressed("ui_left"):
		translate(Vector3(0,0,0.4))
	if Input.is_action_pressed("ui_right"):
		translate(Vector3(0,0,-0.4))
	if Input.is_action_pressed("ui_up"):
		get_parent().rotate_x(0.001)
	if Input.is_action_pressed("ui_down"):
		get_parent().rotate_x(-0.001)
		
	# 32 is the game resolution width times the sprite pixel size (0.1)
	# 16 is half that
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
	
	# Create offset for screenshake
	transform.origin.x = offset.x
	transform.origin.y = offset.y


func screenshake(magnitude, decay):
	shaking = true
	shake_magnitude = magnitude
	shake_decay = decay
