extends Area2D
class_name FireSpell

func _ready() -> void:
	for children in get_children():
		if children is Particles2D:
			children.emitting = true
			
			
func on_animation_finished(_anim_name: String) -> void:
	queue_free()
