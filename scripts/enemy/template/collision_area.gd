extends Area2D
class_name CollisionArea

export(int) var health

export(NodePath) onready var enemy_bar = get_node(enemy_bar) as Control
export(NodePath) onready var enemy_ref = get_node(enemy_ref) as KinematicBody2D 

func _ready() -> void:
	enemy_bar.init_bar(health)
	
	
func on_collision_area_entered(area) -> void:
	var player_stats: Node = area.get_parent().get_node("Stats")
	var player_attack: int = player_stats.base_attack + player_stats.bonus_attack
	update_health(player_attack)
	
	
func update_health(damage: int) -> void:
	health -= damage
	enemy_bar.update_bar(health)
	enemy_ref.spawn_floating_text("-", "Damage", damage)
	
	if health <= 0: 
		enemy_ref.can_die = true
		return
		
	enemy_ref.can_hit = true
