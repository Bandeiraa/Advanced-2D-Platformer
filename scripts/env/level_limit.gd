extends Node2D
class_name LevelLimit

const WATER: PackedScene = preload("res://scenes/interactable/water.tscn")
const STEP: int = 96

export(int) var left_gap
export(int) var right_gap

func _ready() -> void:
	spawn_water_tile()
	
	
func spawn_water_tile() -> void:
	for step in range(left_gap, right_gap, STEP):
		var water_tile: Water = WATER.instance()
		water_tile.global_position = Vector2(step, 0)
		add_child(water_tile)
