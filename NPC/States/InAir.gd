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
	
	owner.move_and_slide(owner.velocity, Vector3.UP)
	owner.velocity.y -= owner.grav_force
	
	if owner.is_on_floor() and owner.velocity.y < 0:
		state_machine.transition_to("Idle")

# Called when exiting state
func exit():
	pass
