extends Area


onready var target = get_parent().get_parent().get_node("Player")
onready var cam_anchor = get_parent().get_parent().get_node("CameraAnchor")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_RightCamArea_body_entered(body):
	if body is Player:
		#cam_anchor.target_rotation = 90
		cam_anchor.change_angle(90)


func _on_RightCamArea_body_exited(body):
	if body is Player:
		#cam_anchor.target_rotation = 0
		cam_anchor.change_angle(0)
