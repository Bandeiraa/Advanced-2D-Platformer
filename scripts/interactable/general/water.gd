extends InteractableTemplate
class_name Water

onready var splash_effect_list: Array = [
	preload("res://scenes/effect/water/water_splash_1.tscn"),
	preload("res://scenes/effect/water/water_splash_2.tscn")
]

func on_body_entered(body: Player) -> void:
	spawn_effect(body.global_position)
	
	
func spawn_effect(body_position: Vector2) -> void:
	randomize()
	var random_number: int = randi() % splash_effect_list.size()
	var effect = splash_effect_list[random_number].instance()
	get_tree().root.call_deferred("add_child", effect)
	effect.global_position = body_position + Vector2(0, 16)
	effect.play_effect()
