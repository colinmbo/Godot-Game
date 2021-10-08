extends PlayerState


var dir = Vector2(0,0)
var force = 0
var height = 0
var stun = 0


# Called when first entering state
func enter():
	
	sprite.material_override.set_shader_param("Is_White", true)
	player.velocity.y = height
	
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
func update(delta):
	
	if stun <= 0:
		stun = 0
		state_machine.transition_to("InAir")
		sprite.material_override.set_shader_param("Is_White", false)
	else:
		stun -= 1


# Called once per physics frame
func physics_update(delta):
	
	player.velocity.x = dir.x * force
	player.velocity.z = dir.y * force
	if player.is_on_floor():
		force -= 1
		if force <= 0:
			force = 0
	
	player.velocity.y += player.grav_force
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)
