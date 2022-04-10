extends CanvasLayer

signal start

onready var animation: AnimationPlayer = get_node("Animation")

var target_level_path: String

func fade_in(level_path: String) -> void:
	target_level_path = level_path
	animation.play("fade_in")
	
	
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			var _change_scene: bool = get_tree().change_scene(target_level_path)
			animation.play("fade_out")
			
		"fade_out":
			emit_signal("start")
