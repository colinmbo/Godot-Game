extends Spatial

export var sound_effect : AudioStream


func _ready():
	pass



func _on_Area_body_entered(body):
	if body is Player:
		
		var sound_player = AudioStreamPlayer3D.new()
		owner.add_child(sound_player)
		sound_player.unit_db = 0.5
		sound_player.unit_size = 100
		sound_player.connect("finished", sound_player, "queue_free")
		sound_player.stream = sound_effect
		sound_player.play()
		
		queue_free()
