extends Camera


func _ready():
	# 36 is the game resolution width times the sprite pixel size (0.1)
	# 18 is half that
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
		
	# 36 is the game resolution width times the sprite pixel size (0.1)
	# 18 is half that
	set_fov(2*rad2deg(atan(18/get_translation().z)))
