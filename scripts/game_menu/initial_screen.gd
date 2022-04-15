extends Control
class_name InitialScreen

onready var animation: AnimationPlayer = get_node("GameMenu/Animation")
onready var initial_container: Control = get_node("GameMenu/InitialContainer")
onready var character_select_container: Control = get_node("GameMenu/SelectCharacter")

func _ready() -> void:
	var _start: bool = TransitionScreen.connect("start", self, "start_game")
	
	
func start_game() -> void:
	animation.play("show_container")
	
	
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"show_container":
			initial_container.connect_buttons()
			character_select_container.connect_buttons()
