extends Node

var menu_node : TabContainer
var card_tab_node : VBoxContainer
var badge_tab_node : VBoxContainer
var current_card_focus : Control
var current_badge_focus : Control

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_node = get_node("CanvasLayer2/TabContainer")
	menu_node.visible = false
	card_tab_node = menu_node.get_node("Cards/VBoxContainer")
	badge_tab_node = menu_node.get_node("Badges/VBoxContainer")
	current_card_focus = card_tab_node.get_child(0)
	current_badge_focus = badge_tab_node.get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("pause"):
		if !menu_node.visible:
			menu_node.visible = true
			get_tree().paused = true
			current_card_focus.grab_focus()
		else:
			menu_node.visible = false
			get_tree().paused = false
		
	# Go to badges menu
	if get_tree().paused:
		if Input.is_action_just_pressed("ui_right"):
			if menu_node.current_tab == 0:
				current_card_focus = menu_node.get_focus_owner()
				menu_node.current_tab = 1
				current_badge_focus.grab_focus()
		
		# Go to cards menu
		if Input.is_action_just_pressed("ui_left"):
			if menu_node.current_tab == 1:
				current_badge_focus = menu_node.get_focus_owner()
				menu_node.current_tab = 0
				current_card_focus.grab_focus()
