extends KinematicBody

onready var animatedSprite = $AnimatedSprite3D
onready var shadowRay = $ShadowRay
onready var shadow = $Shadow
onready var interactRay = $InteractRay
onready var interact = $Interact

onready var fs1 = $Footstep1
onready var fs2 = $Footstep2
onready var fs3 = $Footstep3
onready var fs4 = $Footstep4
onready var jumpSound = $JumpSound
onready var thumpSound = $ThumpSound

export var footstep_sound1 : AudioStream
export var footstep_sound2 : AudioStream
export var footstep_sound3 : AudioStream
export var footstep_sound4 : AudioStream
export var jump_sound : AudioStream
export var thump_sound : AudioStream

export var move_speed = 9.0
export var jump_force = 20.0
export var grav_force = 1.0

var facing_direction := 270
var velocity = Vector3.ZERO


func _ready():
	pass


func _process(delta):
	
	rotation_degrees = Vector3(0,facing_direction,0)
	
	#Shadow stuff
	if (shadowRay.is_colliding()):
		shadow.show()
		shadow.global_transform.origin.y = (shadowRay.get_collision_point().y + 0.05)
	else:
		shadow.hide()


func _physics_process(delta):
	pass

func end_interaction():
	$StateMachine.transition_to("Idle")
	
func get_hurt():
	print("hit")
	$StateMachine.transition_to("Hurt")
