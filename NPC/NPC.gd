extends KinematicBody

onready var animatedSprite = $AnimatedSprite3D

var velocity = Vector3.ZERO

export var facing_direction := 90
export var grav_force = 1.0

export var dialog = [
	"Sample text",
]

const textboxScene = preload("res://Textbox/Textbox.tscn")

func _ready():
	facing_direction = round(facing_direction * 90) / 90


func _process(delta):
	pass


func _physics_process(delta):
	pass

func interacted():
	var textbox = textboxScene.instance()
	textbox.dialog = dialog
	owner.get_node("HUDCanvas").add_child(textbox)
