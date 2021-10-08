extends PlayerState


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
