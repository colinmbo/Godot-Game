extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO


func _ready():
	yield(owner, "ready")
	player = owner as Player
	sprite = player.sprite
	anim = player.anim
	interact_ray = player.interact_ray


# Called when first entering state
func enter():
	player.get_node("AnimationTree").get("parameters/playback").travel("Running")

# Called once per frame
func update(_delta):
	
	# Update input vector
	input_vec = Vector2(
		int(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		int(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()
	
	# Update facing direction
	if input_vec != Vector2.ZERO:
		player.facing_dir = input_vec.angle()

# Called once per physics frame
func physics_update(_delta):
	
	# Add gravity when grounded to detect floor
	player.velocity.y += player.grav_force
	
	# Transition to air state if not grounded
	if !player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
	# If there is input, accelerate towards max speed
	if input_vec.length() > 0:
		player.move_vec = player.move_vec.move_toward(input_vec * player.max_speed, player.move_accel)
		player.global_facing = player.move_vec.normalized()
		
	# If there is no input, decelerate towards zero
	else:
		player.move_vec = player.move_vec.move_toward(Vector2.ZERO, player.move_decel)
	
	# Set target velocity
	var target_velocity = Vector3(player.move_vec.x, player.velocity.y, player.move_vec.y)
	
	# Move the player based on velocity	
	player.velocity = player.move_and_slide_with_snap(target_velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)

	# Transition to air state when jump is pressed
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jumping")
	
	# Transition to attack state when attack is pressed
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
	
	# CHANGE THIS TO RETURN TO IDLE STATE AS SOON AS THERE IS NO INPUT, HANDLE SLIDING IN IDLE STATE
	# Transition to idle state when there is no input
	elif Vector2(player.velocity.x, player.velocity.z).length() <= 0.1:
		if input_vec.length() == 0:
			state_machine.transition_to("Idle")
		else:
			# you are hitting a wall
			pass
	
	# Transition to interact state when interact is pressed with collider found
	elif Input.is_action_just_pressed("interact"):
		var collider = interact_ray.get_collider()
		if collider != null:
			if collider.has_method("interacted"):
				collider.interacted()
				state_machine.transition_to("Interacting")


# Called when exiting state
func exit():
	pass
