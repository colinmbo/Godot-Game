class_name StateMachine
extends Node

export var initial_state = NodePath()
onready var current_state = get_node(initial_state)

func _ready():
	# Runs the ready event of the Player first
	yield(owner, "ready")
	current_state.enter()
	
func _process(delta):
	current_state.update(delta)
	
func _physics_process(delta):
	current_state.physics_update(delta)
	
func transition_to(target_state_name):
	current_state.exit()
	current_state = get_node(target_state_name)
	current_state.enter()
