class_name Player
extends KinematicBody


export var max_speed = 15.0
export var move_accel = 2.0
export var move_decel = 1.0
export var jump_force = 20.0
export var grav_force = -1.1
export var hold_grav_scalar = 0.6
export var fall_grav_scalar = 1.5
export var floor_snap = 0.2
export var facing_turn = 0.25

onready var sprite = $Sprite3D
onready var anim = $AnimationPlayer
onready var interact_ray = $InteractRay

onready var shadow = $Shadow
onready var shadow_ray = $ShadowRay

var health := 100

var move_vec := Vector2.ZERO
var velocity := Vector3.ZERO

var facing := Vector2(0, 1)


func _ready():
	pass


func _process(_delta):
	
	#Shadow stuff
	if (shadow_ray.is_colliding()):
		shadow.show()
		shadow.global_transform.origin.y = (shadow_ray.get_collision_point().y + 0.01)
		if global_transform.origin.y - shadow_ray.get_collision_point().y > 20:
			shadow.scale = Vector3.ONE - (Vector3.ONE * (global_transform.origin.y - shadow_ray.get_collision_point().y - 20)) * 0.1
		else:
			shadow.scale = Vector3.ONE
	else:
		shadow.hide()
	
	# Facing Direction
	var cam_anchor = get_viewport().get_camera().get_parent()
	var relative_facing = facing.rotated(cam_anchor.rotation.y)
	$Anchor.transform.basis.z = Vector3(facing.x, 0, facing.y)
	
	#Set proper animation facing direction
	$AnimationTree.set("parameters/Idle/blend_position", Vector2(relative_facing.x, -relative_facing.y))
	$AnimationTree.set("parameters/Running/blend_position", Vector2(relative_facing.x, -relative_facing.y))
	$AnimationTree.set("parameters/Jumping/blend_position", Vector2(relative_facing.x, -relative_facing.y))
	
	
func end_interaction():
	
	$StateMachine.transition_to("Idle")


func _on_Hurtbox_area_entered(area):
	if area.owner.attack_user == self:
		return
	
	#get_viewport().get_camera().hitlag(5)
	get_viewport().get_camera().screenshake(1, 0.1)
	var state = get_node("StateMachine/Hurt")
	state.dir = Vector2(
		(transform.origin - area.owner.transform.origin).x, 
		(transform.origin - area.owner.transform.origin).z
	)
	state.force = area.owner.force
	state.height = area.owner.height
	state.stun = area.owner.stun
	
	area.owner.queue_free()

	$StateMachine.transition_to("Hurt")
