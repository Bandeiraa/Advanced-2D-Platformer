extends Node2D
class_name EnemySpawner

onready var spawn_timer: Timer = get_node("Timer")

export(Array, Array) var enemies_list

export(float) var spawn_cooldown

export(int) var left_gap_position
export(int) var right_gap_position

func _ready() -> void:
	randomize()
	spawn_timer.start(spawn_cooldown)
	
	
func on_timer_timeout() -> void:
	spawn_enemy()
	
	
func spawn_enemy() -> void:
	var random_enemy_index: int = randi() % enemies_list.size()
	var enemy_list: Array = enemies_list[random_enemy_index]
	var enemy = load(enemy_list[0]).instance()
	enemy.connect("kill", self, "on_enemy_killed")
	enemy.global_position = Vector2(spawn_position(), enemy_list[1])
	add_child(enemy)
	
	
func spawn_position() -> float:
	return rand_range(left_gap_position, right_gap_position)
	
	
func on_enemy_killed() -> void:
	spawn_timer.start(spawn_cooldown)
