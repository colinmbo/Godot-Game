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
	
	# Update input vector
	input_vec = Vector2(
		int(Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")),
		int(Input.get_action_strength("move_down") 
			- Input.get_action_strength("move_up"))
	)
	input_vec = input_vec.normalized()
	
	timer = attack_time
	
	# Spawn projectile
	var spell_inst = spell.instance()
	get_tree().get_root().add_child(spell_inst)
	get_viewport().get_camera().screenshake(0.3, 0.1)
	spell_inst.transform.origin = player.transform.origin
	spell_inst.dir = input_vec
	spell_inst.attack_user = player
	if input_vec.length() <= 0.1:
		spell_inst.dir = player.facing
	
	var dist = 20
	var angle_diff = 180
	var target_node = null
	var target_angle = spell_inst.dir
	for n in get_tree().get_nodes_in_group("enemies"):
		var ppos = player.global_transform.origin
		var ppos2d = Vector2(ppos.x, ppos.z)
		var npos = n.global_transform.origin
		var npos2d = Vector2(npos.x, npos.z)
		
		var current_angle = ppos2d.direction_to(npos2d).angle_to(spell_inst.dir)

#		if abs(current_angle) < angle_diff:
#			angle_diff = abs(current_angle)
#			if abs(current_angle) < PI/4:
#				target_node = n
#				target_angle = ppos2d.direction_to(npos2d)

		#Create ray to destination
		
		
		var is_unlocked = true
		if abs(current_angle) < PI/4 || is_unlocked:
			var current_dist = ppos.distance_to(npos)
			if current_dist < dist:
				dist = current_dist
				target_node = n
				target_angle = ppos2d.direction_to(npos2d)
		
	if target_node != null:
		spell_inst.dir = (target_angle)


# Called once per frame
func update(_delta):
	timer -= 1
	if timer <= 0:
		state_machine.transition_to("Idle")


# Called once per physics frame
func physics_update(_delta):
	player.velocity = player.move_and_slide(player.velocity, Vector3.UP)


# Called when exiting state
func exit():
	pass

