class_name PlayerState
extends State


var player : Player

var sprite : Sprite3D
var anim : AnimationPlayer
var interact_ray : RayCast


func _ready():
	
	yield(owner, "ready")
	
	player = owner as Player
	
	sprite = player.sprite
	anim = player.anim
	interact_ray = player.interact_ray
