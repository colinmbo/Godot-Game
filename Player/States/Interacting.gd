extends State


var player : Player
var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast
var input_vec := Vector2.ZERO


func _ready():
	yield(owner, "ready")
	player = owner as Player
	sprite = player.sprite
	anim = player.anim
	interact_ray = player.interact_ray


# Called when first entering state
func enter():
	
	player.velocity = Vector3.ZERO
