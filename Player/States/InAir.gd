extends PlayerState


var input_vec := Vector2.ZERO
var cam_input_vec := Vector2.ZERO
var init_vel_xz := Vector2.ZERO


# Called when first entering state
func enter():
	
	match player.facing_dir:
		0:
			anim.play("jump_side")
			sprite.set_flip_h(false)
		90:
			anim.play("jump_back")
			sprite.set_flip_h(false)
		180:
			anim.play("jump_side")
			sprite.set_flip_h(true)
		270:
			anim.play("jump_front")
			sprite.set_flip_h(false)
		
	player.anim.stop()
	
	init_vel_xz = Vector2(player.velocity.x, player.velocity.z)


# Called once per frame
func update(_delta):
	
	input_vec = Vector2(
		int(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		int(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()
	
	var cam = get_viewport().get_camera()
	cam_input_vec = Vector2(
		cam.global_transform.basis.z.x * input_vec.y,
		cam.global_transform.basis.z.z * input_vec.y
	)
	cam_input_vec.x += cam.global_transform.basis.x.x * input_vec.x
	cam_input_vec.y += cam.global_transform.basis.x.z * input_vec.x


# Called once per physics frame
func physics_update(_delta):
	
	player.velocity += Vector3(cam_input_vec.x, 0, cam_input_vec.y) * 0.4
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
