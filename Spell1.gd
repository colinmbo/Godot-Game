extends Spatial



func _ready():
	pass

func _process(delta):
	pass


func _on_Area_body_entered(body):
	if body.has_method("get_hurt"):
		var body_pos_2d = Vector2(body.global_transform.origin.x, body.global_transform.origin.z)
		var spell_pos_2d = Vector2(global_transform.origin.x, global_transform.origin.z)
		var dir = body_pos_2d - spell_pos_2d
		body.get_hurt(dir, 10, 10, 10, 30)
