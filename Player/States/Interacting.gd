extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO


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
