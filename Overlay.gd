extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("pause"):
		var menu_node = get_node("CanvasLayer2/ColorRect")
		menu_node.visible = !menu_node.visible
		get_tree().paused = !get_tree().paused
