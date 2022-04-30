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
	player.get_node("AnimationTree").get("parameters/playback").travel("Idle")
	player.move_vec = Vector2.ZERO


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
	
	# Add gravity when grounded to detect floor
	player.velocity.y += player.grav_force
	
	# Move the player based on velocity
	player.velocity = player.move_and_slide_with_snap(player.velocity, 
		Vector3.DOWN * player.floor_snap, Vector3.UP, true, 4, PI/5)
		
	# Transition to air state if not grounded
	if !player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
	# Transition to air state when jump is pressed
	if Input.is_action_just_pressed("jump"):
		player.velocity = Vector3.ZERO
		state_machine.transition_to("Jumping")
	
	# Transition to attack state when attack is pressed
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")
	
	# Transition to idle state when there is no input
	elif input_vec.x != 0 or input_vec.y != 0:
		state_machine.transition_to("Running")
		
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
