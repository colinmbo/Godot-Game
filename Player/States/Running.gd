extends PlayerState


var input_vec := Vector2.ZERO


# Called when first entering state
func enter():
	
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


# Called once per frame
func update(delta):
	
	input_vec = Vector2(
		int(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		int(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()
	
	if !is_equal_approx(input_vec.length(), 0.0):
		player.facing_dir = facing_from_vec(Vector2(input_vec.x, -input_vec.y))
	
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
func physics_update(delta):
	
	if !player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
#	if (!is_equal_approx(input_vec.length(), 0.0)):
#		player.facing_direction = round(rad2deg(Vector2(input_vec.x,-input_vec.y).angle())/90.0)*90.0
#		player.facing_direction = posmod(player.facing_direction, 360)
	
	player.velocity.x = input_vec.x * player.move_speed
	player.velocity.z = input_vec.y * player.move_speed
	
	player.velocity.y = player.grav_force
	
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_force
		player.play_sound_3d(player.jump_sound, 15, 10)
		state_machine.transition_to("InAir")
		
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
		
	elif is_equal_approx(input_vec.length(), 0):
		state_machine.transition_to("Idle")
		
	elif Input.is_action_just_pressed("interact"):
		var collider = interact_ray.get_collider()
		if collider != null:
			if collider.has_method("interacted"):
				collider.interacted()
				state_machine.transition_to("Interacting")


func facing_from_vec(vec):
	var dir = rad2deg(vec.angle())
	return posmod(round(dir / 90) * 90, 360)


func play_footstep():
	var num = randi() % 3
	match num:
		0: player.play_sound_3d(player.footstep_sound1, 15, 10)
		1: player.play_sound_3d(player.footstep_sound1, 15, 10)
		2: player.play_sound_3d(player.footstep_sound1, 15, 10)
		3: player.play_sound_3d(player.footstep_sound1, 15, 10)
