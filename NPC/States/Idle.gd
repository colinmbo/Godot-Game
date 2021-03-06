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
	
	owner.velocity.y = -0.1
	owner.move_and_slide_with_snap(owner.velocity, Vector3(0, -0.1, 0), Vector3.UP, true)
	
	if !owner.is_on_floor():
		state_machine.transition_to("InAir")

# Called when exiting state
func exit():
	pass
