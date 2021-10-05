extends KinematicBody


export var dialog = [""]
export var facing_direction := 270
export var grav_force = 1.0

onready var animatedSprite = $AnimatedSprite3D

var velocity = Vector3.ZERO

const textboxScene = preload("res://Textbox/Textbox.tscn")


func _ready():
	facing_direction = round(facing_direction * 90) / 90


func _process(delta):
	pass


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
	textbox.connect("dialog_exited", owner.get_node("Player"), "end_interaction")
	textbox.connect("dialog_exited", self, "end_interaction")
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
