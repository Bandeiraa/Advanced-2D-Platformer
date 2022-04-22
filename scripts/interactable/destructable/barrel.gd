extends DestructableInteractable

var barrel_slice: Array = [
	"res://assets/interactable/barrel/destroyed_barrel_1.png",
	"res://assets/interactable/barrel/destroyed_barrel_2.png",
	"res://assets/interactable/barrel/destroyed_barrel_3.png",
	"res://assets/interactable/barrel/destroyed_barrel_4.png"
]

func spawn() -> void:
	for slice_path in barrel_slice:
		var slice: Slice = SLICE.instance()
		slice.slice_texture_path = slice_path
		slice.global_position = global_position
		get_tree().root.call_deferred("add_child", slice)
		
		
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		animation.play("idle")
