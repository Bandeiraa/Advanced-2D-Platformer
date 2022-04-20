extends Control
class_name SelectCharacter

onready var character_container: HBoxContainer = get_node("CharacterSelectContainer")

var can_click: bool = false
var target_level_path: String = "res://scenes/management/level.tscn"

func connect_buttons() -> void:
	for container in character_container.get_children():
		var button: Button = container.get_child(1)
		var _exited: bool = button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		var _entered: bool = button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
		var _pressed: bool = button.connect("pressed", self, "on_button_pressed", [button])
		
		
func mouse_interaction(button: Button, state: String) -> void:
	match state:
		"entered":
			can_click = true
			button.modulate.a = .5
			
		"exited":
			can_click = false
			button.modulate.a = 1.0
			
			
func on_button_pressed(button: Button) -> void:
	var player_path: String
	if can_click:
		reset(button)
		match button.name:
			"Blue":
				player_path = "res://assets/player/char_blue.png"
				
			"Red":
				player_path = "res://assets/player/char_red.png"
				
			"Green":
				player_path = "res://assets/player/char_green.png"
				
			"Purple":
				player_path = "res://assets/player/char_purple.png"
				
		can_click = false
		start_game(player_path)
		
		
func reset(button: Button) -> void:
	button.modulate.a = .2
	yield(get_tree().create_timer(.1), "timeout")
	if not can_click:
		button.modulate.a = 1.0
	else:
		button.modulate.a = .5
		
		
func start_game(player_skin: String) -> void:
	DataManagement.data_dictionary["current_level_path"] = target_level_path
	DataManagement.data_dictionary["player_texture"] = player_skin
	DataManagement.save_data()
	
	TransitionScreen.fade_in(target_level_path, false)
