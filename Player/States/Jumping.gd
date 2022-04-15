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
	state_machine.transition_to("InAir")


# Play appropriate animation based on facing direction
func set_anim(dir, front_anim, side_anim, back_anim):
	
	match player.relative_facing:
		0.0, PI*2:
			anim.play(front_anim)
			sprite.set_flip_h(false)
		PI*0.5:
			anim.play(side_anim)
			sprite.set_flip_h(false)
		PI*1:
			anim.play(back_anim)
			sprite.set_flip_h(false)
		PI*1.5:
			anim.play(side_anim)
			sprite.set_flip_h(true)
