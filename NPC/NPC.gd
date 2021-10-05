extends KinematicBody


export var dialog = [""]
export var facing_direction := 90
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
	var textbox = textboxScene.instance()
	textbox.connect("dialog_exited", owner.get_node("Player"), "end_interaction")
	textbox.dialog = dialog
	owner.get_node("HUDCanvas").add_child(textbox)
