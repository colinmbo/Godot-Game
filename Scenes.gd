extends Spatial

var timer = 15
var is_fade_out = false

var room1 = load("res://SnowyRoom.tscn/").instance()
var room2 = load("res://DebugRoom1.tscn/").instance()
var room3 = load("res://LobbyRoom.tscn/").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(room3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $AnimationPlayer.is_playing():
		if $AnimationPlayer.current_animation == "FadeOut":
			is_fade_out = true
		else:
			is_fade_out = false
	
	if Input.is_action_just_pressed("transition"):
		if is_fade_out:
			remove_child(room1)
			add_child(room2)
			$AnimationPlayer.play("FadeIn")
		else:
			$AnimationPlayer.play("FadeOut")
	
	timer -= 1
	if timer == 0:
		$AnimationPlayer.play("FadeIn")
