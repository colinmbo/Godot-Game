extends State

# Called when first entering state
func enter():
	match owner.facing_direction:
		0:
			owner.animatedSprite.set_animation("runSide")
			owner.animatedSprite.set_flip_h(false)
		90:
			owner.animatedSprite.set_animation("runBack")
			owner.animatedSprite.set_flip_h(false)
		180:
			owner.animatedSprite.set_animation("runSide")
			owner.animatedSprite.set_flip_h(true)
		270:
			owner.animatedSprite.set_animation("runFront")
			owner.animatedSprite.set_flip_h(false)
		
	owner.animatedSprite.set_frame(1)
	owner.animatedSprite.play()
	
	
# Called once per frame
func update(delta):
	pass

# Called once per physics frame
func physics_update(delta):
	
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	input_direction = input_direction.normalized()
	
	if (!is_equal_approx(input_direction.length(), 0.0)):
		owner.facing_direction = round(rad2deg(Vector2(input_direction.x,-input_direction.y).angle())/90.0)*90.0
		owner.facing_direction = posmod(owner.facing_direction, 360)
		
		var current_frame = owner.animatedSprite.get_frame()
		match owner.facing_direction:
			0:
				owner.animatedSprite.set_animation("runSide")
				owner.animatedSprite.set_flip_h(false)
				owner.animatedSprite.set_frame(current_frame)
			90:
				owner.animatedSprite.set_animation("runBack")
				owner.animatedSprite.set_flip_h(false)
				owner.animatedSprite.set_frame(current_frame)
			180:
				owner.animatedSprite.set_animation("runSide")
				owner.animatedSprite.set_flip_h(true)
				owner.animatedSprite.set_frame(current_frame)
			270:
				owner.animatedSprite.set_animation("runFront")
				owner.animatedSprite.set_flip_h(false)
				owner.animatedSprite.set_frame(current_frame)
			
		owner.animatedSprite.play()
	
	owner.velocity.x = input_direction.x * owner.move_speed
	owner.velocity.y = -0.1
	owner.velocity.z = input_direction.y * owner.move_speed
	owner.move_and_slide_with_snap(owner.velocity, Vector3(0, -0.1, 0), Vector3.UP, true)
	
	if owner.animatedSprite.get_frame() % 2 == 0:
		if (!owner.fs1.is_playing() and !owner.fs2.is_playing() and 
			!owner.fs3.is_playing() and !owner.fs4.is_playing()):
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var num = rng.randi_range(0, 3)
			match num:
				0:
					owner.fs1.play()
				1:
					owner.fs2.play()
				2:
					owner.fs3.play()
				3:
					owner.fs4.play()
	
	if owner.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			owner.velocity.y = owner.jump_force
			owner.jumpSound.play()
			state_machine.transition_to("InAir")
		elif Input.is_action_just_pressed("action"):
			#Run attack here?
			state_machine.transition_to("Attacking")
		elif is_equal_approx(input_direction.length(), 0.0):
			state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("InAir")
		
	if Input.is_action_just_pressed("interact"):
		var collider = owner.interactRay.get_collider()
		if collider != null:
			if collider.has_method("interacted"):
				collider.interacted()
				state_machine.transition_to("Interacting")

# Called when exiting state
func exit():
	pass
