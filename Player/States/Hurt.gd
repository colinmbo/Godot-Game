extends State


var dir = Vector2(0,0)
var force = 0
var height = 0
var stun = 0

# Called when first entering state
func enter():
	owner.animatedSprite.material_override.set_shader_param("Is_White", true)
	owner.velocity.y = height
	
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
	if stun <= 0:
		stun = 0
		state_machine.transition_to("InAir")
		owner.animatedSprite.material_override.set_shader_param("Is_White", false)
	else:
		stun -= 1


# Called once per physics frame
func physics_update(delta):
	owner.velocity.x = dir.x * force
	owner.velocity.z = dir.y * force
	if owner.is_on_floor():
		force -= 1
		if force <= 0:
			force = 0
	owner.move_and_slide_with_snap(owner.velocity, Vector3(0, -0.1, 0), Vector3.UP, true)
	owner.velocity.y -= owner.grav_force

# Called when exiting state
func exit():
	pass
