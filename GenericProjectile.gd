extends Spatial

var dir := Vector2(0,0)
export var force : float
export var height : float
export var stun : float
export var dmg : float


func _ready():
	pass


func _process(delta):
	transform.origin.x += dir.x * 0.25
	transform.origin.z += dir.y * 0.25
