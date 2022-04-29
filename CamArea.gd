extends Area


export var x_rotation := 0.0
export var y_rotation := 0.0

onready var target = get_parent().get_parent().get_node("Player")
#onready var cam_anchor = get_parent().get_parent().get_node("CameraAnchor")
onready var cam_anchor = get_viewport().get_camera().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_CamRegion_body_entered(body):
	if body is Player:
		cam_anchor.target_rot = Vector2(x_rotation, y_rotation)


func _on_CamRegion_body_exited(body):
	if body is Player:
		cam_anchor.target_rot = cam_anchor.default_rot
