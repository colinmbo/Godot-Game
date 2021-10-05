extends Control


export var type_speed = 0.4
export var vocal1 : AudioStream
export var vocal2 : AudioStream

# Raw dialog with special chars
var dialog = []
# Dialog with special chars removed
var clean_dialog = []
# Index for the current page of dialog displayed
var page_index = 0
# Number of characters currently displayed
var visible_chars = 0
# Removes special chars and controls dialog pace
var char_scanner = 0


func _ready():
	
	# Copy dialog to clean dialog with special chars removed
	for t in dialog:
		clean_dialog.append(t.replace("/",""))
	
	$RichTextLabel.set_text(clean_dialog[page_index])


func _process(delta):
	
	# If the current scanned char is special, increment the scanner slower
	# Otherwise, increment the scanner and visible chars by the typing speed
	var current_scan_char = dialog[page_index].substr(floor(char_scanner) - 1, 1)
	if current_scan_char == "/":
		char_scanner += type_speed * 0.1
	else:
		char_scanner += type_speed
		visible_chars += type_speed
	
	# Play random voice sound if a new char just became visible
	var current_vis_char = clean_dialog[page_index].substr(floor(visible_chars) - 1, 1)
	if floor(visible_chars - type_speed) < floor(visible_chars):
		# Don't play sound when encountering certain chars
		if (current_vis_char != " " and current_vis_char != "," 
				and current_vis_char != "." and current_vis_char != "!" 
				and current_vis_char != "?" and current_vis_char != ""):
			var voice_player = AudioStreamPlayer3D.new()
			add_child(voice_player)
			voice_player.unit_db = 5
			voice_player.unit_size = 10
			voice_player.connect("finished", voice_player, "queue_free")
			var num = randi() % 3
			match num:
				0: voice_player.stream = vocal1
				1: voice_player.stream = vocal2
				_: voice_player.queue_free()
			voice_player.play()
	
	# If all the text has been displayed, cap off scanner and visible chars
	if char_scanner >= dialog[page_index].length():
		char_scanner = dialog[page_index].length()
		visible_chars = clean_dialog[page_index].length()
		
		# If button is pressed, go to next dialog page
		# If there is no more dialog, delete the textbox
		if Input.is_action_just_pressed("interact"):
			char_scanner = 0
			visible_chars = 0
			page_index += 1
			if page_index >= dialog.size():
				queue_free()
			else:
				$RichTextLabel.set_text(clean_dialog[page_index])
	else:
		# Skip dialog on input if the text is still being typed out
		if Input.is_action_just_pressed("cancel"):
			char_scanner = dialog[page_index].length()
			visible_chars = clean_dialog[page_index].length()
	
	$RichTextLabel.set_visible_characters(visible_chars)
