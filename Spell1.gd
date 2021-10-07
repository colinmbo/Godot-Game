extends Spatial



func _ready():
	pass

func _process(delta):
	pass


func _on_Area_body_entered(body):
	if body.has_method("get_hurt"):
		body.get_hurt()
