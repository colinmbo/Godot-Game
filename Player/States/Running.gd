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
	pass

# Called once per frame
func update(_delta):
	
	# Update input vector
	input_vec = Vector2(
		int(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		int(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()
	
	# Update facing direction
	if input_vec != Vector2.ZERO:
		player.facing_dir = input_vec.angle()
	
	# Play appropriate animation
	set_anim(player.facing_dir, "run_front", "run_side", "run_back")

# Called once per physics frame
func physics_update(_delta):
	
	# Transition to air state if not grounded
	if !player.is_on_floor():
		state_machine.transition_to("InAir")
		return

	# CHANGED FOR CAMERA RELATIVITY
	player.velocity.x += (get_viewport().get_camera().global_transform.basis.x.x * input_vec.x + input_vec.y * get_viewport().get_camera().global_transform.basis.z.x) *3
	player.velocity.z += (get_viewport().get_camera().global_transform.basis.x.z * input_vec.x + input_vec.y * get_viewport().get_camera().global_transform.basis.z.z) *3
	#player.velocity += Vector3(input_vec.x, 0, input_vec.y) * 3
	var stored_vel = Vector2(player.velocity.x, player.velocity.z)
	if stored_vel.length() > player.move_speed:
		player.velocity.x = stored_vel.normalized().x * player.move_speed
		player.velocity.z = stored_vel.normalized().y * player.move_speed
	
	# Add gravity when grounded to detect floor
	player.velocity.y = player.grav_force
	
	player.global_facing = Vector2(player.velocity.x, player.velocity.z).normalized()
	
	# Move the player based on velocity
	player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true)
	
	# Transition to air state when jump is pressed
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jumping")
	
	# Transition to attack state when attack is pressed
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
	
	# Transition to idle state when there is no input
	elif input_vec.x == 0 and input_vec.y == 0:
		state_machine.transition_to("Idle")
	
	# Transition to interact state when interact is pressed with collider found
	elif Input.is_action_just_pressed("interact"):
		var collider = interact_ray.get_collider()
		if collider != null:
			if collider.has_method("interacted"):
				collider.interacted()
				state_machine.transition_to("Interacting")


# Called when exiting state
func exit():
	pass


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
