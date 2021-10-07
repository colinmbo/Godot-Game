extends Spatial


var life = 40
var time_to_destroy = 20
var destroy = false

func _ready():
	pass


func _process(delta):
	if life <= 0:
		life = 0
		$Particles.emitting = false
		destroy = true
	life -= 1
	
	if destroy:
		time_to_destroy -= 1
	if time_to_destroy <= 0:
		queue_free()


func _on_Area_body_entered(body):
	if body.has_method("get_hurt"):
		var body_pos_2d = Vector2(body.global_transform.origin.x, body.global_transform.origin.z)
		var spell_pos_2d = Vector2(global_transform.origin.x, global_transform.origin.z)
		var dir = body_pos_2d - spell_pos_2d
		body.get_hurt(dir, 10, 10, 10, 30)
