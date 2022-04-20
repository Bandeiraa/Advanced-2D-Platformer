extends Control
class_name InitialContainer

onready var buttons_container: VBoxContainer = get_node("ButtonsContainer")

var can_click: bool = false
var target_level_path: String = "res://scenes/management/level.tscn"

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

func connect_buttons() -> void:
	for button in buttons_container.get_children():
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
		
		
func mouse_interaction(button: Button, state: String) -> void:
	match state:
		"entered":
			can_click = true
			button.modulate.a = .5
				
		"exited":
			can_click = false
			button.modulate.a = 1.0
			
			
func on_button_pressed(button: Button) -> void:
	match button.name:
		"Play":
			if can_click:
				reset(button)
				var file = File.new()
				if file.file_exists(DataManagement.save_path):
					TransitionScreen.fade_in(target_level_path, false)
				else:
					animation.play("character_select")
					
		"Options":
			reset(button)
			
		"Quit":
			if can_click:
				reset(button)
				get_tree().quit()
				
				
func reset(button: Button) -> void:
	can_click = false
	button.modulate.a = .2
	yield(get_tree().create_timer(.1), "timeout")
	if not can_click:
		button.modulate.a = 1.0
	else:
		button.modulate.a = .5
