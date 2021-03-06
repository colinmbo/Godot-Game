extends PlayerState


var input_vec := Vector2.ZERO


# Called when first entering state
func enter():
	
	player.anim.stop()


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


# Called once per physics frame
func physics_update(_delta):
	
	# CHANGED FOR CAMERA RELATIVITY
	player.velocity.x += (get_viewport().get_camera().global_transform.basis.x.x * input_vec.x + input_vec.y * get_viewport().get_camera().global_transform.basis.z.x) *0.6
	player.velocity.z += (get_viewport().get_camera().global_transform.basis.x.z * input_vec.x + input_vec.y * get_viewport().get_camera().global_transform.basis.z.z) *0.6
	#player.velocity += Vector3(input_vec.x, 0, input_vec.y) * 0.4
	var vel_xz = Vector2(player.velocity.x, player.velocity.z)
	player.velocity.x = vel_xz.clamped(player.move_speed).x
	player.velocity.z = vel_xz.clamped(player.move_speed).y
	
	player.velocity.y += player.grav_force
	player.move_and_slide(player.velocity, Vector3.UP)
	
	if player.velocity.y > 0:
		match player.facing_dir:
			0:
				sprite.frame = 20
				sprite.set_flip_h(false)
			90:
				sprite.frame = 33
				sprite.set_flip_h(false)
			180:
				sprite.frame = 20
				sprite.set_flip_h(true)
			270:
				sprite.frame = 7
				sprite.set_flip_h(false)
	else:
		match player.facing_dir:
			0:
				sprite.frame = 21
				sprite.set_flip_h(false)
			90:
				sprite.frame = 34
				sprite.set_flip_h(false)
			180:
				sprite.frame = 21
				sprite.set_flip_h(true)
			270:
				sprite.frame = 8
				sprite.set_flip_h(false)
	
	if player.is_on_floor() and player.velocity.y < 0:
		player.play_sound_3d(player.thump_sound, 15, 10)
		if is_equal_approx(input_vec.length(), 0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Running")
			
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
