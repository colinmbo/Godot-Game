extends PlayerState


var input_vec := Vector2.ZERO


# Called when first entering state
func enter():
	
	player.velocity = Vector3.ZERO
	
	match player.facing_dir:
		0:
			anim.play("idle_side")
			sprite.set_flip_h(false)
		90:
			anim.play("idle_back")
			sprite.set_flip_h(false)
		180:
			anim.play("idle_side")
			sprite.set_flip_h(true)
		270:
			anim.play("idle_front")
			sprite.set_flip_h(false)


# Called once per frame
func update(_delta):
	
	input_vec = Vector2(
		int(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		int(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()


# Called once per physics frame
func physics_update(_delta):
	
	if !player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
	#I changed this from being -0.1, might not work now
	player.velocity.y = player.grav_force
	
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_force
		player.play_sound_3d(player.jump_sound, 15, 10)
		state_machine.transition_to("InAir")
		
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
		
	elif !is_equal_approx(input_vec.length(), 0):
		state_machine.transition_to("Running")
		
	elif Input.is_action_just_pressed("interact"):
		var collider = interact_ray.get_collider()
		if collider != null:
			if collider.has_method("interacted"):
				collider.interacted()
				state_machine.transition_to("Interacting")
