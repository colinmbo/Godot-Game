extends PlayerState


var input_vec := Vector2.ZERO


# Called when first entering state
func enter():
	
	# Set player velocity to zero
	player.velocity = Vector3.ZERO
	
	# Change facing direction
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
	
	# Change facing direction
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
	
	# Set input vector based on directional input and normalize
	input_vec = Vector2(
		(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()


# Called once per physics frame
func physics_update(_delta):
	
	# Transition to air state if not on the floor
	if !player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
	# Apply gravity to y velocity
	player.velocity.y = player.grav_force
	
	# Move player using velocity
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)
	
	# Jump when pressing the jump button
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_force
		player.play_sound_3d(player.jump_sound, 15, 10)
		state_machine.transition_to("InAir")
		
	# Transition to attack state when action is pressed
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
	
	# Transition to running state f there is directional input
	elif !is_equal_approx(input_vec.length(), 0):
		state_machine.transition_to("Running")
	
	# Interact when pressing the interact button
	elif Input.is_action_just_pressed("interact"):
		var collider = interact_ray.get_collider()
		if collider != null:
			if collider.has_method("interacted"):
				collider.interacted()
				state_machine.transition_to("Interacting")
