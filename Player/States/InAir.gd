extends State

# Called when first entering state
func enter():
	
	match owner.facing_direction:
		0:
			owner.animatedSprite.set_animation("jumpSide")
			owner.animatedSprite.set_flip_h(false)
		90:
			owner.animatedSprite.set_animation("jumpBack")
			owner.animatedSprite.set_flip_h(false)
		180:
			owner.animatedSprite.set_animation("jumpSide")
			owner.animatedSprite.set_flip_h(true)
		270:
			owner.animatedSprite.set_animation("jumpFront")
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
	
	owner.velocity += Vector3(input_direction.x,0,input_direction.y)*0.4
	if Vector2(owner.velocity.x,owner.velocity.z).length() > owner.move_speed+1:
		owner.velocity.x = Vector2(owner.velocity.x,owner.velocity.z).normalized().x * (owner.move_speed)
		owner.velocity.z = Vector2(owner.velocity.x,owner.velocity.z).normalized().y * (owner.move_speed)
	
	owner.move_and_slide(owner.velocity, Vector3.UP)
	owner.velocity.y -= owner.grav_force
	
	if owner.velocity.y > 0:
		owner.animatedSprite.set_frame(2)
	else:
		owner.animatedSprite.set_frame(3)
	
	if owner.is_on_floor() and owner.velocity.y < 0:
		var thump_player = AudioStreamPlayer3D.new()
		owner.add_child(thump_player)
		thump_player.unit_db = 15
		thump_player.unit_size = 10
		thump_player.connect("finished", thump_player, "queue_free")
		thump_player.stream = owner.thump_sound
		thump_player.play()
		if input_direction.length() > 0:
			state_machine.transition_to("Running")
		else:
			state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("action"):
		#Do air attack here
		# state_machine.transition_to("Attacking")
		pass

# Called when exiting state
func exit():
	pass
