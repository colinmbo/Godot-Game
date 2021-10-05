extends Control

export var typeSpeed = 0.5

export var vocal1 : AudioStream
export var vocal2 : AudioStream


var dialog = ["Empty dialog"]
var cleanDialog = []
var dialog_index = 0
var visible_chars = 0
var char_scanner = 0


func _ready():
	for t in dialog:
		cleanDialog.append(t.replace("/",""))
		
	$RichTextLabel.set_text(cleanDialog[dialog_index])


func _process(delta):
	
	if char_scanner < dialog[dialog_index].length():
		
		var last_visible_chars = visible_chars
		var currentChar = dialog[dialog_index].substr(char_scanner-1, 1)
		if currentChar == "/":
			char_scanner += typeSpeed*0.1
		else:
			char_scanner += typeSpeed
			visible_chars += typeSpeed
			
		currentChar = dialog[dialog_index].substr(char_scanner-1, 1)
		if fmod(visible_chars, 1.0) < fmod(last_visible_chars, 1.0):
				if (currentChar != " " && currentChar != "," && 
				currentChar != "." && currentChar != "!"):
					var soundPlayer = AudioStreamPlayer3D.new()
					add_child(soundPlayer)
					soundPlayer.unit_db = 5
					soundPlayer.unit_size = 10
					var rng = RandomNumberGenerator.new()
					rng.randomize()
					var num = rng.randi_range(0, 2)
					match num:
						0:
							soundPlayer.stream = vocal1
						1:
							soundPlayer.stream = vocal2
					soundPlayer.play()
					
		#Skip dialog	
		if Input.is_action_just_pressed("cancel"):
			char_scanner = dialog[dialog_index].length()
			visible_chars = cleanDialog[dialog_index].length()
			
	else:
		char_scanner = dialog[dialog_index].length()
		visible_chars = cleanDialog[dialog_index].length()
		
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("action") or Input.is_action_just_pressed("cancel"):
			visible_chars = 0
			char_scanner = 0
			dialog_index += 1
			if dialog_index >= dialog.size():
				#FIRE SIGNAL THAT THE TEXTBOX HAS ENDED
				queue_free()
			else:
				$RichTextLabel.set_text(cleanDialog[dialog_index])
	
	$RichTextLabel.set_visible_characters(visible_chars)
