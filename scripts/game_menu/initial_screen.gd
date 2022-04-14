extends Control
class_name InitialScreen

onready var game_menu: CanvasLayer = get_node("GameMenu")
onready var animation: AnimationPlayer = game_menu.get_node("Animation")
onready var buttons_container: VBoxContainer = game_menu.get_node("ButtonsContainer")

var can_click: bool = false
var target_level_path: String = "res://scenes/management/level.tscn"

func _ready() -> void:
	var _start: bool = TransitionScreen.connect("start", self, "start_game")
	
	
func start_game() -> void:
	animation.play("show_container")
	
	
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
				can_click = false
				TransitionScreen.fade_in(target_level_path)
				
		"Options":
			reset(button)
			
		"Quit":
			if can_click:
				reset(button)
				can_click = false
				get_tree().quit()
				
				
func reset(button: Button) -> void:
	button.modulate.a = .2
	yield(get_tree().create_timer(.1), "timeout")
	if not can_click:
		button.modulate.a = 1.0
	else:
		button.modulate.a = .5
		
		
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"show_container":
			for button in buttons_container.get_children():
				button.connect("pressed", self, "on_button_pressed", [button])
				button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
				button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
