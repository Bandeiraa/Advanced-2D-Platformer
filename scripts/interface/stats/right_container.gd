extends TextureRect
class_name StatsRightContainer

onready var v_container: VBoxContainer = get_node("VContainer")

var stats_points: int = 0

export(NodePath) onready var points_info = get_node(points_info) as TextureRect

func _ready() -> void:
	var file = File.new()
	if file.file_exists(DataManagement.save_path):
		stats_points = DataManagement.data_dictionary["stats_points"]
		
	points_info.update_text_value(str(stats_points))
	for children in v_container.get_children():
		var button: TextureButton = children.get_node("Plus")
		var _pressed: bool = button.connect("pressed", self, "verify_stat", [children.name])
		var _exited: bool = button.connect("mouse_exited", self, "mouse_interaction", ["exited", button])
		var _entered: bool = button.connect("mouse_entered", self, "mouse_interaction", ["entered", button])
		
		
func mouse_interaction(type: String, container) -> void:
	match type:
		"entered":
			container.modulate.a = 0.5
			points_info.play_animation("show_container")
			
		"exited":
			container.modulate.a = 1.0
			points_info.play_animation("hide_container")
			
			
func verify_stat(stat: String) -> void:
	match stat:
		"HealthContainer":
			apply_weight(1, "Health")
			
		"ManaContainer":
			apply_weight(1, "Mana")
			
		"AttackContainer":
			apply_weight(3, "Attack")
			
		"MagicAttackContainer":
			apply_weight(3, "Magic Attack")
			
		"DefenseContainer":
			apply_weight(5, "Defense")
			
			
func apply_weight(weight: int, stat: String) -> void:
	if stats_points >= weight:
		stats_points -= weight
		points_info.update_text_value(str(stats_points))
		get_tree().call_group("player_stats", "update_stats", stat)
		DataManagement.data_dictionary["stats_points"] = stats_points
		DataManagement.save_data()  
		
		
func reset() -> void:
	for children in v_container.get_children():
		var button: TextureButton = children.get_node("Plus")
		if button.modulate.a != 1.0:
			button.modulate.a = 1.0
			points_info.play_animation("hide_container")
			
			
func update_avaliable_points(value: int) -> void:
	stats_points += value
	DataManagement.data_dictionary["stats_points"] = stats_points
	DataManagement.save_data()
	points_info.update_text_value(str(stats_points))
