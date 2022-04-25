extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO

var can_jetpack = false


func _ready():
	yield(owner, "ready")
	player = owner as Player
	sprite = player.sprite
	anim = player.anim
	interact_ray = player.interact_ray


# Called when first entering state
func enter():
	
	player.anim.stop()
	can_jetpack = false


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
	
	if Input.is_action_just_pressed("jump"):
		can_jetpack = true
		
	if can_jetpack and Input.is_action_pressed("jump"):
		player.velocity.y += 2
		
	
	# CHANGED FOR CAMERA RELATIVITY
	player.move_vec += input_vec * 0.4
	player.move_vec.x = player.move_vec.clamped(player.max_speed).x
	player.move_vec.y = player.move_vec.clamped(player.max_speed).y
	
	player.velocity.y += player.grav_force
	
	var target_velocity = Vector3(player.move_vec.x, player.velocity.y, player.move_vec.y)
	player.velocity = player.move_and_slide(target_velocity, Vector3.UP)
	
	# USE MOVE_VEC TO KEEP MOMENTUM UPON LANDING!!
	
	# SET ANIMATION HERE
	
	if player.is_on_floor() and player.velocity.y < 0:
		if is_equal_approx(player.move_vec.length(), 0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Running")
			
	elif Input.is_action_just_pressed("action"):
		state_machine.transition_to("Attacking")

func exit():
	pass
