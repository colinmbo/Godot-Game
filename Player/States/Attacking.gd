extends State

var attack_time = 12
var timer = 0

var spell = preload("res://Spell1.tscn")

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
	timer = attack_time
	
	var spellInst = spell.instance()
	spellInst.user = owner
	get_tree().get_root().get_node("Main").add_child(spellInst)
	spellInst.global_transform.origin = (owner.global_transform.origin + 
		Vector3(Vector2.RIGHT.rotated(deg2rad(owner.facing_direction)).x, 
		0, Vector2.RIGHT.rotated(-deg2rad(owner.facing_direction)).y) * 2)

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
