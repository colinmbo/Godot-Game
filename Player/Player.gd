class_name Player
extends KinematicBody


export var max_speed = 15.0
export var move_accel = 2.0
export var move_decel = 1.0
export var jump_force = 20.0
export var grav_force = -1.0
export var floor_snap = 0.2

onready var sprite = $Sprite3D
onready var anim = $AnimationPlayer
onready var interact_ray = $InteractRay

onready var shadow = $Shadow
onready var shadow_ray = $ShadowRay

var health := 100

var move_vec := Vector2.ZERO
var velocity := Vector3.ZERO

var global_facing = Vector2(0, 1)
var facing_dir := 270
var relative_facing = 0

var afterimg_pos_queue = []
var afterimg_frame_queue = []


func _ready():
	pass


func _process(_delta):
	
	#Afterimage
	afterimg_pos_queue.push_front($Sprite3D.global_transform.origin)
	afterimg_frame_queue.push_front($Sprite3D.frame)
	if afterimg_pos_queue.size() > 2:
		$AfterImage.global_transform.origin = afterimg_pos_queue[2] + Vector3.FORWARD * 0.01
		$AfterImage.frame = afterimg_frame_queue[2]
		if afterimg_pos_queue.size() > 4:
			$AfterImage2.global_transform.origin = afterimg_pos_queue[4] + Vector3.FORWARD * 0.02
			$AfterImage2.frame = afterimg_frame_queue[4]
			if afterimg_pos_queue.size() > 6:
				$AfterImage3.global_transform.origin = afterimg_pos_queue[6] + Vector3.FORWARD * 0.03
				$AfterImage3.frame = afterimg_frame_queue[6]
				if afterimg_pos_queue.size() > 9:
					afterimg_pos_queue.pop_back()
					afterimg_frame_queue.pop_back()
	
	#Set proper animation facing direction
	$AnimationTree.set("parameters/Idle/blend_position", Vector2(global_facing.x, -global_facing.y))
	$AnimationTree.set("parameters/Running/blend_position", Vector2(global_facing.x, -global_facing.y))
	$AnimationTree.set("parameters/Jumping/blend_position", Vector2(global_facing.x, -global_facing.y))
	
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
	var cam_facing = get_viewport().get_camera().global_transform.basis.z
	var cam_facing_flat = Vector2(cam_facing.x, cam_facing.z).normalized()
	relative_facing = global_facing.angle_to(cam_facing_flat)
	relative_facing = stepify(fposmod(relative_facing, PI*2), PI*0.5)
	$Anchor.transform.basis.z = Vector3(global_facing.x, 0, global_facing.y)
	
	
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
