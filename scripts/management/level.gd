extends Node2D
class_name GameLevel

onready var player: KinematicBody2D = get_node("Player")
onready var level_height: Node2D = get_node("LevelLimit")

var can_process_height: bool = true
var current_level_path: String = "res://scenes/management/level.tscn"

func _ready() -> void:
	if GlobalInfo.checkpoint:
		player.global_position = GlobalInfo.checkpoint_position
		
	var _aux_camera: bool = player.get_node("Texture").connect("aux_camera", self, "aux_camera")
	
	
func aux_camera(player_position: Vector2) -> void:
	can_process_height = false
	var camera: Camera2D = Camera2D.new()
	add_child(camera)
	camera.limit_top = 0
	camera.current = true
	camera.global_position = player_position
	
	
func _process(_delta: float) -> void:
	if can_process_height and player.global_position.y > level_height.global_position.y:
		TransitionScreen.fade_in(current_level_path)
		can_process_height = false
