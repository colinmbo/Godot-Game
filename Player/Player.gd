class_name Player
extends KinematicBody


export var move_speed = 9.0
export var jump_force = 20.0
export var grav_force = -1.0
export var floor_snap = 0.1

export var footstep_sound1 : AudioStream
export var footstep_sound2 : AudioStream
export var footstep_sound3 : AudioStream
export var footstep_sound4 : AudioStream
export var jump_sound : AudioStream
export var thump_sound : AudioStream

onready var sprite = $Sprite3D
onready var anim = $AnimationPlayer
onready var interact_ray = $InteractRay
onready var shadow = $Shadow
onready var shadow_ray = $ShadowRay

var health := 100
var facing_dir := 270
var velocity := Vector3.ZERO
var input_vec := Vector2.ZERO


func _process(_delta):
	
	transform = transform.orthonormalized()
	
	var cam = get_viewport().get_camera()
	var relative_facing = Vector2(
	transform.basis.z.dot(cam.global_transform.basis.x),
	-transform.basis.x.dot(cam.global_transform.basis.x)
	)
	facing_dir = fposmod(round(rad2deg(relative_facing.angle()) / 90) * 90, 360)
	
	#Shadow stuff
	if (shadow_ray.is_colliding()):
		shadow.show()
		shadow.global_transform.origin.y = (shadow_ray.get_collision_point().y + 0.05)
	else:
		shadow.hide()


func end_interaction():
	$StateMachine.transition_to("Idle")


func get_hurt(dir, force, height, dmg, stun):
	dir = dir.normalized()
	
	$StateMachine/Hurt.dir = dir
	$StateMachine/Hurt.force = force
	$StateMachine/Hurt.height = height
	$StateMachine/Hurt.stun = stun
	
	health -= dmg
	$StateMachine.transition_to("Hurt")	


func play_sound_3d(sound, unit_db, unit_size):
	var sound_player = AudioStreamPlayer3D.new()
	add_child(sound_player)
	sound_player.unit_db = unit_db
	sound_player.unit_size = unit_size
	sound_player.connect("finished", sound_player, "queue_free")
	sound_player.stream = sound
	sound_player.play()
