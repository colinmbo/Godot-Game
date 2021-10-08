extends KinematicBody


export var target : NodePath

onready var sprite = $Sprite3D
onready var anim = $AnimationPlayer
onready var shadow_ray = $ShadowRay
onready var shadow = $Shadow

var facing_dir := 270


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Shadow stuff
	if (shadow_ray.is_colliding()):
		shadow.show()
		shadow.global_transform.origin.y = (shadow_ray.get_collision_point().y + 0.05)
	else:
		shadow.hide()
	
	var target_pos_2d = Vector2(get_node(target).global_transform.origin.x, -get_node(target).global_transform.origin.z)
	var pos_2d = Vector2(global_transform.origin.x, -global_transform.origin.z)
	var dir = rad2deg(target_pos_2d.angle_to_point(pos_2d))
	facing_dir = posmod(int(round(dir / 90) * 90), 360)
	
	match facing_dir:
		0:
			anim.play("side")
			sprite.set_flip_h(false)
		90:
			anim.play("back")
			sprite.set_flip_h(false)
		180:
			anim.play("side")
			sprite.set_flip_h(true)
		270:
			anim.play("front")
			sprite.set_flip_h(false)
