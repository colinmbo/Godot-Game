extends KinematicBody


export var dialog = [""]
export var facing_direction := 270
export var grav_force = 1.0

onready var animatedSprite = $AnimatedSprite3D
onready var shadowRay = $ShadowRay
onready var shadow = $Shadow

var health = 50
var velocity = Vector3.ZERO

var move_time = 60
var move_meter = 0
var is_moving = false

const textboxScene = preload("res://Textbox/Textbox.tscn")


func _ready():
	facing_direction = round(facing_direction / 90) * 90
	
	match facing_direction:
		0:
			animatedSprite.set_animation("runSide")
			animatedSprite.set_flip_h(false)
		90:
			animatedSprite.set_animation("runBack")
			animatedSprite.set_flip_h(false)
		180:
			animatedSprite.set_animation("runSide")
			animatedSprite.set_flip_h(true)
		270:
			animatedSprite.set_animation("runFront")
			animatedSprite.set_flip_h(false)
	animatedSprite.stop()
	animatedSprite.set_frame(0)


func _process(delta):
	
	animatedSprite.material_override.set_shader_param("cam_dist", owner.get_node("CameraAnchor").get_node("Camera").get_translation().z)
	
	randomize()

	if !is_moving:
		animatedSprite.stop()
		animatedSprite.set_frame(0)
		var rand = rand_range(0, 100)
		if round(rand) <= 0:
			facing_direction = int(round(rand_range(0, 360) / 90) * 90)
			rotation_degrees = Vector3(0,facing_direction,0)
			is_moving = true
			move_meter = move_time
			match facing_direction:
				0, 360:
					animatedSprite.set_animation("runSide")
					animatedSprite.set_flip_h(false)
				90:
					animatedSprite.set_animation("runBack")
					animatedSprite.set_flip_h(false)
				180:
					animatedSprite.set_animation("runSide")
					animatedSprite.set_flip_h(true)
				270:
					animatedSprite.set_animation("runFront")
					animatedSprite.set_flip_h(false)
			animatedSprite.play()
			animatedSprite.set_frame(0)
	else:
		move_and_slide(global_transform.basis.z * 1, Vector3.UP, false)
		move_meter -= 1
		if move_meter <= 0:
			is_moving = false
		
	
	rotation_degrees = Vector3(0,facing_direction,0)
	
	#Shadow stuff
	if (shadowRay.is_colliding()):
		shadow.show()
		shadow.global_transform.origin.y = (shadowRay.get_collision_point().y + 0.05)
	else:
		shadow.hide()
		
	if health <= 0:
		die()


func _physics_process(delta):
	pass


func interacted():
	var interactor = owner.get_node("Player")
	facing_direction = round(rad2deg(Vector2(-global_transform.origin.x, global_transform.origin.z).angle_to_point(
		Vector2(-interactor.global_transform.origin.x, interactor.global_transform.origin.z)))/90)*90
	facing_direction = posmod(facing_direction, 360)
	match facing_direction:
		0:
			animatedSprite.set_animation("runSide")
			animatedSprite.set_flip_h(false)
		90:
			animatedSprite.set_animation("runBack")
			animatedSprite.set_flip_h(false)
		180:
			animatedSprite.set_animation("runSide")
			animatedSprite.set_flip_h(true)
		270:
			animatedSprite.set_animation("runFront")
			animatedSprite.set_flip_h(false)
	animatedSprite.stop()
	animatedSprite.set_frame(0)
	var textbox = textboxScene.instance()
	textbox.connect("dialog_exited", interactor, "end_interaction")
	textbox.connect("dialog_exited", self, "end_interaction")
	textbox.speaker = self
	textbox.dialog = dialog
	owner.get_node("HUDCanvas").add_child(textbox)

func end_interaction():
	facing_direction = 270
	match facing_direction:
		0:
			animatedSprite.set_animation("runSide")
			animatedSprite.set_flip_h(false)
		90:
			animatedSprite.set_animation("runBack")
			animatedSprite.set_flip_h(false)
		180:
			animatedSprite.set_animation("runSide")
			animatedSprite.set_flip_h(true)
		270:
			animatedSprite.set_animation("runFront")
			animatedSprite.set_flip_h(false)
	animatedSprite.stop()
	animatedSprite.set_frame(0)
	
func get_hurt(dir, force, height, dmg, stun):
	dir = dir.normalized()
	
	$StateMachine/Hurt.dir = dir
	$StateMachine/Hurt.force = force
	$StateMachine/Hurt.height = height
	$StateMachine/Hurt.stun = stun
	
	health -= dmg
	$StateMachine.transition_to("Hurt")
	
func die():
	queue_free()

# Play randomized footstep sound effect, called by AnimationPlayer
func play_footstep():
	var num = randi() % 3
	match num:
		0: play_sound_3d(get_parent().player.footstep_sound1, 15, 10)
		1: play_sound_3d(get_parent().player.footstep_sound2, 15, 10)
		2: play_sound_3d(get_parent().player.footstep_sound3, 15, 10)
		3: play_sound_3d(get_parent().player.footstep_sound4, 15, 10)

func play_sound_3d(sound, unit_db, unit_size):
	var sound_player = AudioStreamPlayer3D.new()
	add_child(sound_player)
	sound_player.unit_db = unit_db
	sound_player.unit_size = unit_size
	sound_player.connect("finished", sound_player, "queue_free")
	sound_player.stream = sound
	sound_player.play()


func _on_Hurtbox_area_entered(area):
	print(area)
	queue_free()
