extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO


var dir = Vector2(0,0)
var force = 0
var height = 0
var stun = 0


func _ready():
	yield(owner, "ready")
	player = owner as Player
	sprite = player.sprite
	anim = player.anim
	interact_ray = player.interact_ray


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
func update(_delta):
	
	if stun <= 0:
		stun = 0
		state_machine.transition_to("InAir")
		sprite.material_override.set_shader_param("Is_White", false)
	else:
		stun -= 1


# Called once per physics frame
func physics_update(_delta):
	
	player.velocity.x = dir.x * force
	player.velocity.z = dir.y * force
	if player.is_on_floor():
		force -= 1
		if force <= 0:
			force = 0
	
	player.velocity.y += player.grav_force
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)


# Called when exiting state
func exit():
	pass
