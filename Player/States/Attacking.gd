extends State

var timer = 50

const spell = preload("res://Spell1.tscn")

# Called when first entering state
func enter():
			
	owner.velocity = Vector3.ZERO
	match owner.facing_direction:
		0:
			owner.animatedSprite.set_animation("attackSide")
			owner.animatedSprite.set_flip_h(false)
		90:
			owner.animatedSprite.set_animation("attackBack")
			owner.animatedSprite.set_flip_h(false)
		180:
			owner.animatedSprite.set_animation("attackSide")
			owner.animatedSprite.set_flip_h(true)
		270:
			owner.animatedSprite.set_animation("attackFront")
			owner.animatedSprite.set_flip_h(false)
	owner.animatedSprite.stop()
	owner.animatedSprite.set_frame(1)
	timer = 50
	
	var spellInst = spell.instance()
	get_tree().get_root().add_child(spellInst)
	spellInst.set_translation(owner.get_translation() + Vector3(-3,0,0))

# Called once per frame
func update(delta):
	timer-=1
	if timer <= 0:
		state_machine.transition_to("Idle")

# Called once per physics frame
func physics_update(delta):
	pass

# Called when exiting state
func exit():
	pass
