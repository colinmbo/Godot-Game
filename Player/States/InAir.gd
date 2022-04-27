extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO

var can_hold = true
var can_jetpack = false
var buffer_time = 10
var buffer_timer = 0
var init_move_vec = Vector2.ZERO

func _ready():
	yield(owner, "ready")
	player = owner as Player
	sprite = player.sprite
	anim = player.anim
	interact_ray = player.interact_ray


# Called when first entering state
func enter():
	
	player.get_node("AnimationTree").get("parameters/playback").travel("Idle")
	can_hold = true
	can_jetpack = false
	
	init_move_vec = player.move_vec


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
	
	if player.move_vec.length() > 0.1:
		player.global_facing = player.move_vec.normalized()


# Called once per physics frame
func physics_update(_delta):
	
	buffer_timer = max(buffer_timer-1, 0)
	
	if Input.is_action_just_pressed("jump"):
	#	can_jetpack = true
		buffer_timer = buffer_time
		
	if !Input.is_action_pressed("jump"):
		can_hold = false
		
	#jetpack stuff
	if can_jetpack and Input.is_action_pressed("jump"):
		player.velocity.y += 2
	
	player.move_vec += input_vec * player.move_accel * 0.6
	player.move_vec.x = player.move_vec.clamped(max(player.max_speed, init_move_vec.length())).x
	player.move_vec.y = player.move_vec.clamped(max(player.max_speed, init_move_vec.length())).y
	
	if player.velocity.y > 0 and can_hold:
		player.velocity.y += player.grav_force * 0.6
	else:
		player.velocity.y += player.grav_force
	
	if player.velocity.y < 0:
		player.velocity.y += player.grav_force * 0.5
	
	var target_velocity = Vector3(player.move_vec.x, player.velocity.y, player.move_vec.y)
	player.velocity = player.move_and_slide(target_velocity, Vector3.UP)
	
	# SET ANIMATION HERE
	
	if player.is_on_floor() and target_velocity.y < 0:
		get_viewport().get_camera().screenshake(min(abs(target_velocity.y) / 50, 0.5), 0.05, 0.25, 1.0)
		if buffer_timer > 0:
			state_machine.transition_to("Jumping")
		elif is_equal_approx(player.move_vec.length(), 0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Running")
		
		var jump_particle = load("res://JumpParticle.tscn").instance()
		get_tree().get_root().add_child(jump_particle)
		jump_particle.transform.origin = player.transform.origin + Vector3.UP * 0.3
		jump_particle.get_node("AnimationPlayer").play("Land")
			
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")

func exit():
	pass
