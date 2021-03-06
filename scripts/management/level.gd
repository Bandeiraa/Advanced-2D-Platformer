extends Node2D
class_name GameLevel

onready var player: KinematicBody2D = get_node("Player")
onready var level_height: Node2D = get_node("LevelLimit")
onready var interface: CanvasLayer = get_node("Interface")

var can_process_height: bool = true
var current_level_path: String = "res://scenes/management/level.tscn"

func _ready() -> void:
	var _game_over: bool = player.get_node("Texture").connect("game_over", self, "on_game_over")
	
	
func on_game_over() -> void:
	interface.hide_containers()
	TransitionScreen.fade_in(current_level_path, false)
	
	
func _process(_delta: float) -> void:
	if can_process_height and player.global_position.y > level_height.global_position.y:
		get_tree().call_group("inventory", "reset_inventory")
		DataManagement.data_dictionary["armor_container"] = []
		DataManagement.data_dictionary["weapon_container"] = []
		DataManagement.data_dictionary["consumable_container"] = []
		DataManagement.data_dictionary["current_health"] = player.stats.base_health
		DataManagement.data_dictionary["current_mana"] = player.stats.base_mana
		DataManagement.save_data()
		
		TransitionScreen.fade_in(current_level_path, false)
		can_process_height = false
