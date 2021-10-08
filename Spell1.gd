extends Spatial

export var hit_sound : AudioStream

var user = null
var damage = 10
var knockback_force = 10
var knockback_height = 10
var stun = 30
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
	if body != user and body.has_method("get_hurt"):
		var body_pos_2d = Vector2(body.global_transform.origin.x, body.global_transform.origin.z)
		var user_pos_2d = Vector2(user.global_transform.origin.x, user.global_transform.origin.z)
		var dir = body_pos_2d - user_pos_2d
		body.get_hurt(dir, knockback_force, knockback_height, damage, stun)
		play_sound_3d(hit_sound, 15, 10)
		get_parent().get_node("CameraAnchor").get_node("Camera").screenshake(0.5, 0.1)


func play_sound_3d(sound, unit_db, unit_size):
	var sound_player = AudioStreamPlayer3D.new()
	add_child(sound_player)
	sound_player.unit_db = unit_db
	sound_player.unit_size = unit_size
	sound_player.connect("finished", sound_player, "queue_free")
	sound_player.stream = sound
	sound_player.play()
