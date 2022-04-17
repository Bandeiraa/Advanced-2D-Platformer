extends Area2D
class_name FireSpell

func _ready() -> void:
	for children in get_children():
		if children is Particles2D:
			children.emitting = true
