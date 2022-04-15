extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO

var attack_time = 12
var timer = 0

var spell = preload("res://GenericProjectile.tscn")


func _ready():
	yield(owner, "ready")
	player = owner as Player
	sprite = player.sprite
	anim = player.anim
	interact_ray = player.interact_ray


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
	
	# Spawn projectile
	var spell_inst = spell.instance()
	get_tree().get_root().add_child(spell_inst)
	spell_inst.transform.origin = player.transform.origin
	spell_inst.dir = player.global_facing


# Called once per frame
func update(_delta):
	
	timer -= 1
	if timer <= 0:
		state_machine.transition_to("Idle")


# Called once per physics frame
func physics_update(_delta):
	pass


# Called when exiting state
func exit():
	pass

