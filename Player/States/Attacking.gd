extends PlayerState


var attack_time = 12
var timer = 0

var spell = preload("res://Spell1.tscn")


# Called when first entering state
func enter():
			
	player.velocity = Vector3.ZERO
	
	match player.facing_dir:
		0:
			anim.play("attack_side")
			sprite.set_flip_h(false)
		90:
			anim.play("attack_back")
			sprite.set_flip_h(false)
		180:
			anim.play("attack_side")
			sprite.set_flip_h(true)
		270:
			anim.play("attack_front")
			sprite.set_flip_h(false)
	
	timer = attack_time
	
	var spell_inst = spell.instance()
	spell_inst.user = player
	
	#This part is not the most elegant
	get_tree().get_root().get_node("Main").add_child(spell_inst)
	var facing_vec = Vector2.RIGHT.rotated(deg2rad(player.facing_dir))
	spell_inst.global_transform.origin = (player.global_transform.origin +
		Vector3(facing_vec.x, 0, -facing_vec.y) * 2)


# Called once per frame
func update(_delta):
	timer -= 1
	if timer <= 0:
		state_machine.transition_to("Idle")
