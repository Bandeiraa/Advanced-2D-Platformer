extends TextureRect
class_name PointsInfo

onready var animation: AnimationPlayer = get_node("Animation")
onready var avaliable_points: Label = get_node("AvaliablePoints")

func update_text_value(points: String) -> void:
	avaliable_points.text = points
	
	
func play_animation(anim_name: String) -> void:
	animation.play(anim_name)
