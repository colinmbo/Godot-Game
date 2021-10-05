extends State


# Called when first entering state
func enter():
			
	owner.velocity = Vector3.ZERO
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
	owner.animatedSprite.stop()
	owner.animatedSprite.set_frame(0)
	
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
	
	owner.velocity.y = -0.1
	owner.move_and_slide_with_snap(owner.velocity, Vector3(0, -0.1, 0), Vector3.UP, true)
	
	if owner.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			owner.velocity.y = owner.jump_force
			owner.jumpSound.play()
			state_machine.transition_to("InAir")
		elif Input.is_action_just_pressed("action"):
			state_machine.transition_to("Attacking")
		elif !is_equal_approx(input_direction.length(), 0.0):
			state_machine.transition_to("Running")
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
