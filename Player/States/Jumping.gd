extends PlayerState


var input_vec := Vector2.ZERO


# Called when first entering state
func enter():
	
	set_anim(player.facing_dir, "jump_front", "jump_side", "jump_back")


# Called once per frame
func update(_delta):
	
	if Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")


# Called once per physics frame
func physics_update(_delta):
	
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)


# Called when exiting state
func exit():
	pass


func jump():
	
	player.velocity.y = player.jump_force
	player.play_sound_3d(player.jump_sound, 15, 10)
	state_machine.transition_to("InAir")


func set_anim(dir, front_anim, side_anim, back_anim):
	
	match dir:
		0:
			anim.play(side_anim)
			sprite.set_flip_h(false)
		90:
			anim.play(back_anim)
			sprite.set_flip_h(false)
		180:
			anim.play(side_anim)
			sprite.set_flip_h(true)
		270:
			anim.play(front_anim)
			sprite.set_flip_h(false)
