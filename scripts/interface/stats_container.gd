extends Control
class_name StatsContainer

onready var animation: AnimationPlayer = get_node("Animation")
onready var stats_animation: AnimationPlayer = get_node("StatsInfo/Animation")
onready var points_animation: AnimationPlayer = get_node("PointsInfo/Animation")

onready var left_grid_container: GridContainer = get_node("LeftContainerBackground/GridContainer")
onready var left_target_stat: TextureRect = get_node("StatsInfo/TargetStat")
onready var stat_text: TextureRect = get_node("StatsInfo/Stat")

onready var right_v_container: VBoxContainer = get_node("RightContainer/VContainer")
onready var points_value: Label = get_node("PointsInfo/AvaliablePoints")
onready var level_value: Label = get_node("RightContainer/Level")

var is_visible: bool = false

var stats_points: int = 0

var stat_image_list: Dictionary = {
	"attack": "res://assets/interface/stats/text/stats_text/small/attack.png",
	"defense": "res://assets/interface/stats/text/stats_text/small/defense.png",
	"health": "res://assets/interface/stats/text/stats_text/small/health.png",
	"magic attack": "res://assets/interface/stats/text/stats_text/small/magic_attack.png",
	"mana": "res://assets/interface/stats/text/stats_text/small/mana.png"
}

func _ready() -> void:
	points_value.text = str(stats_points)
	for children in right_v_container.get_children():
		var button: TextureButton = children.get_node("Plus")
		var _pressed: bool = button.connect("pressed", self, "verify_stat", [children.name])
		var _exited: bool = button.connect("mouse_exited", self, "right_mouse_interaction", ["exited", button])
		var _entered: bool = button.connect("mouse_entered", self, "right_mouse_interaction", ["entered", button])
		
	for container in left_grid_container.get_children():
		container.connect("mouse_exited", self, "mouse_interaction", ["exited", container])
		container.connect("mouse_entered", self, "mouse_interaction", ["entered", container])
		
		
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
				
			stats_animation.play("show_container")
			
		"exited":
			container.modulate.a = 1.0
			stats_animation.play("hide_container")
			
			
func right_mouse_interaction(type: String, container) -> void:
	match type:
		"entered":
			container.modulate.a = 0.5
			points_animation.play("show_container")
			
		"exited":
			container.modulate.a = 1.0
			points_animation.play("hide_container")
			
			
func update_stats_info_container(stat: String) -> void:
	left_target_stat.texture = load(stat_image_list[stat])
	stat_text.texture = load(stat_image_list[stat])
	
	
func verify_stat(stat: String) -> void:
	match stat:
		"HealthContainer":
			apply_weight(1, "Health")
			
		"ManaContainer":
			apply_weight(2, "Mana")
			
		"AttackContainer":
			apply_weight(2, "Attack")
			
		"MagicAttackContainer":
			apply_weight(3, "Magic Attack")
			
		"DefenseContainer":
			apply_weight(5, "Defense")
			
			
func apply_weight(weight: int, stat: String) -> void:
	if stats_points >= weight:
		stats_points -= weight
		points_value.text = str(stats_points)
		get_tree().call_group("player_stats", "update_stats", stat)
		
		
func update_stats(stats_list: Array) -> void:
	for index in left_grid_container.get_child_count():
		var target_stat_text: Label = left_grid_container.get_child(index).get_node("Text")
		target_stat_text.text = str(stats_list[index])
		
		
func reset() -> void:
	for container in left_grid_container.get_children():
		if container.modulate.a != 1.0:
			container.modulate.a = 1.0
			stats_animation.play("hide_container")
			
	for children in right_v_container.get_children():
		var button: TextureButton = children.get_node("Plus")
		if button.modulate.a != 1.0:
			button.modulate.a = 1.0
			points_animation.play("hide_container")
			
			
func update_exp_container(level: int, current_exp: int, level_exp: int) -> void:
	level_value.text = "Level " + str(level) + "\n" + str(current_exp) + "/" + str(level_exp)
	
	
func update_avaliable_points() -> void:
	stats_points += 5
	points_value.text = str(stats_points)
