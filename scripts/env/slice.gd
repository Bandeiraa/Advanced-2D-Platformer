extends RigidBody2D
class_name Slice

onready var player_sprite: Sprite = get_node("Texture")

var slice_texture_path: String

func _ready() -> void:
	player_sprite.texture = load(slice_texture_path)
	randomize()
	
	apply_impulse(Vector2.ZERO, Vector2(
		rand_range(-30, 30),
		rand_range(-30, -120)
	))
	
	
func on_screen_exited() -> void:
	queue_free()
