extends Control
class_name InitialScreen

onready var game_menu: CanvasLayer = get_node("GameMenu")
onready var buttons_container: VBoxContainer = game_menu.get_node("ButtonsContainer")

var target_level_path: String = "res://scenes/management/level.tscn"

func _ready() -> void:
	for button in buttons_container.get_children():
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
		
		
func mouse_interaction(button: Button, state: String) -> void:
	match state:
		"entered":
			button.modulate.a = .5
			
		"exited":
			button.modulate.a = 1.0
			
			
func on_button_pressed(button: Button) -> void:
	reset(button)
	match button.name:
		"Play":
			TransitionScreen.fade_in(target_level_path)
			
		"Options":
			pass
			
		"Quit":
			get_tree().quit()
			
			
func reset(button: Button) -> void:
	button.modulate.a = .2
	yield(get_tree().create_timer(.1), "timeout")
	button.modulate.a = 1.0
