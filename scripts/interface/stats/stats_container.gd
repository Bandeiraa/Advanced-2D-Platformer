extends Control
class_name StatsContainer

onready var animation: AnimationPlayer = get_node("Animation")
onready var left_container: TextureRect = get_node("LeftContainer")
onready var right_container: TextureRect = get_node("RightContainer")

var is_visible: bool = false

func update_stats(stats_list: Array, bonus_stats_list: Array) -> void:
	left_container.update_stats(stats_list, bonus_stats_list)
	
	
func update_bonus_stats(bonus_dict: Dictionary, state: bool) -> void:
	left_container.update_bonus_stats(bonus_dict, state)
	
	
func reset() -> void:
	left_container.reset()
	right_container.reset()
	
	
func update_avaliable_points() -> void:
	right_container.update_avaliable_points(5)
