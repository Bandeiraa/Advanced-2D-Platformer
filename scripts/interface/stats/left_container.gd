extends TextureRect
class_name StatsLeftContainer

onready var grid_container: GridContainer = get_node("GridContainer")

export(NodePath) onready var stats_info = get_node(stats_info) as TextureRect

func _ready() -> void:
	for container in grid_container.get_children():
		default_bonus_value(container)
		container.connect("mouse_exited", self, "mouse_interaction", ["exited", container])
		container.connect("mouse_entered", self, "mouse_interaction", ["entered", container])
		
		
func default_bonus_value(container: HBoxContainer) -> void:
	container.get_node("Bonus").text = ""
	
	
func mouse_interaction(type: String, container) -> void:
	match type:
		"entered":
			container.modulate.a = 0.5
			match container.name:
				"HealthContainer":
					update_stats_info_container("health")
					
				"ManaContainer":
					update_stats_info_container("mana")
					
				"AttackContainer":
					update_stats_info_container("attack")
					
				"MagicAttackContainer":
					update_stats_info_container("magic attack")
					
				"DefenseContainer":
					update_stats_info_container("defense")
				
			stats_info.play_animation("show_container")
			
		"exited":
			container.modulate.a = 1.0
			stats_info.play_animation("hide_container")
			
			
func update_stats_info_container(stat: String) -> void:
	stats_info.update_container(stat)
	
	
func update_stats(stats_list: Array, bonus_stats_list: Array) -> void:
	for index in grid_container.get_child_count():
		var target_stat_text: Label = grid_container.get_child(index).get_node("Text")
		var target_bonus_stat_text: Label = grid_container.get_child(index).get_node("Bonus")
		if bonus_stats_list[index] != 0:
			target_stat_text.text = str(stats_list[index]) + " +"
			target_bonus_stat_text.text = str(bonus_stats_list[index])
		else:
			target_stat_text.text = str(stats_list[index])
			target_bonus_stat_text.text = ""
			
			
func update_bonus_stats(bonus_dict: Dictionary, state: bool) -> void:
	for key in bonus_dict.keys():
		get_tree().call_group("player_stats", "update_bonus_stats", key, bonus_dict[key], state)
		
		
func reset() -> void:
	for container in grid_container.get_children():
		if container.modulate.a != 1.0:
			container.modulate.a = 1.0
			stats_info.play_animation("hide_container")
