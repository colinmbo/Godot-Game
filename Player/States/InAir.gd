extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO

var can_hold = true
var buffer_time = 6
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


# Called once per physics frame
func physics_update(_delta):
	
	# Decrease jump buffer timer
	buffer_timer = max(buffer_timer-1, 0)
	
	# Set jump buffer timer upon pressing jump
	if Input.is_action_just_pressed("jump"):
		buffer_timer = buffer_time
	
	# When jump is no longer being pressed, stop holding the jump velocity
	if !Input.is_action_pressed("jump"):
		can_hold = false
	
	# Get input vector rotated relative to the camera
	var rel_input = input_vec.rotated(-get_viewport().get_camera().get_parent().rotation.y)
	
	# If there is input, accelerate towards max speed and set facing
	if input_vec.length() > 0:
		player.facing = player.facing.slerp(rel_input.normalized(), player.facing_turn)
	
	# Air movement
	var air_control = 0.5
	player.move_vec += rel_input * player.move_accel * air_control
	
	# Clamp air movement
	var max_length = max(player.max_speed, init_move_vec.length())
	player.move_vec = player.move_vec.clamped(max_length)
	
	# Apply gravity and jump holding
	if player.velocity.y >= 0:
		if can_hold: # Lower gravity when holding jump
			player.velocity.y += player.grav_force * player.hold_grav_scalar
		else:
			player.velocity.y += player.grav_force
	else: # Additional gravity when falling
		player.velocity.y += player.grav_force * player.fall_grav_scalar
	
	# Set target velocity
	var target_velocity = Vector3(player.move_vec.x, player.velocity.y, player.move_vec.y)
	
	# Move the player based on velocity	
	player.velocity = player.move_and_slide(target_velocity, Vector3.UP, true, 4, PI/5, false)
	player.move_vec = Vector2(player.velocity.x, player.velocity.z)
	
	# Transition to appropriate state if grounded
	if player.is_on_floor() and target_velocity.y < 0:
		get_viewport().get_camera().screenshake(min(abs(target_velocity.y) / 50, 0.5), 0.05, 0.25, 1.0)
		if buffer_timer > 0:
			state_machine.transition_to("Jumping")
		elif is_equal_approx(player.move_vec.length(), 0):
			state_machine.transition_to("Running")
			#state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Running")
		
		# Jump particle
#		var jump_particle = load("res://JumpParticle.tscn").instance()
#		get_tree().get_root().add_child(jump_particle)
#		jump_particle.transform.origin = player.transform.origin + Vector3.UP * 0.3
#		jump_particle.get_node("AnimationPlayer").play("Land")
			
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")

func exit():
	pass
