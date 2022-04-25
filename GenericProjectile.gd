extends Spatial

var dir := Vector2(0,0)
var attack_user : Node
export var force : float
export var height : float
export var stun : float
export var dmg : float
export var speed : float


func _ready():
	dir = dir.normalized()
	$Timer.start()


func _process(delta):
	transform.origin.x += dir.x * speed
	transform.origin.z += dir.y * speed


func _on_Timer_timeout():
	queue_free()
