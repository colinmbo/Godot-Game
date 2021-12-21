extends PlayerState


var input_vec := Vector2.ZERO
var cam_input_vec := Vector2.ZERO


# Called once per frame
func update(_delta):
	
	# Update input vector
	input_vec = Vector2(
		(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()
	
	var cam = get_viewport().get_camera()
	cam_input_vec = input_vec.rotated(-cam.global_transform.basis.get_euler().y).normalized()
	if !is_equal_approx(input_vec.length(), 0):
		player.rotation.y = Vector2(cam_input_vec.x, -cam_input_vec.y).angle() + PI/2
	
	# Play appropriate animation
	match player.facing_dir:
		0:
			anim.play("run_side")
			sprite.set_flip_h(false)
		90:
			anim.play("run_back")
			sprite.set_flip_h(false)
		180:
			anim.play("run_side")
			sprite.set_flip_h(true)
		270:
			anim.play("run_front")
			sprite.set_flip_h(false)


# Called once per physics frame
func physics_update(_delta):
	
	# Transition to air state if not grounded
	if !player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
	# Set movement velocity
	player.velocity.x = cam_input_vec.x * player.move_speed
	player.velocity.z = cam_input_vec.y * player.move_speed
	
	# Add gravity when grounded to detect floor
	player.velocity.y = player.grav_force
	
	# Move the player based on velocity
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)
	
	# Transition to air state when jump is pressed
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_force
		player.play_sound_3d(player.jump_sound, 15, 10)
		state_machine.transition_to("InAir")
	
	# Transition to attack state when attack is pressed
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
	
	# Transition to idle state when there is no input
	elif input_vec.x == 0 and input_vec.y == 0:
		state_machine.transition_to("Idle")
	
	# Transition to interact state when interact is pressed with collider found
	elif Input.is_action_just_pressed("interact"):
		var collider = interact_ray.get_collider()
		if collider != null:
			if collider.has_method("interacted"):
				collider.interacted()
				state_machine.transition_to("Interacting")


# Play randomized footstep sound effect, called by AnimationPlayer
func play_footstep():
	var num = randi() % 3
	match num:
		0: player.play_sound_3d(player.footstep_sound1, 15, 10)
		1: player.play_sound_3d(player.footstep_sound2, 15, 10)
		2: player.play_sound_3d(player.footstep_sound3, 15, 10)
		3: player.play_sound_3d(player.footstep_sound4, 15, 10)
