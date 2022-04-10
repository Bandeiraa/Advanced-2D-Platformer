extends Node
class_name Stats

onready var invencibility_timer: Timer = get_node("Timer")

var shielding: bool = false

var base_health: int = 35
var base_mana: int = 15
var base_attack: int = 3
var base_magic_attack: int = 5
var base_defense: int = 2

var current_mana: int
var current_health: int

var current_exp: int = 0

var level: int = 1
var level_dict: Dictionary = {
	"1": 15,
	"2": 23,
	"3": 29,
	"4": 36,
	"5": 43,
	"6": 50,
	"7": 57,
	"8": 64,
	"9": 71
}

export(float) var invencibility_time

export(NodePath) onready var collision_area = get_node(collision_area) as Area2D
export(NodePath) onready var player_ref = get_node(player_ref) as KinematicBody2D

func _ready() -> void:
	update_stats_hud()
	current_mana = base_mana
	current_health = base_health
	get_tree().call_group("bar_container", "init_bar", current_health, current_mana, level_dict[str(level)])
	
	
func update_stats(stat: String) -> void:
	match stat:
		"Attack":
			base_attack += 1
			
		"Mana":
			base_mana += 1
			current_mana += 1
			get_tree().call_group("bar_container", "increase_max_value", "Mana", base_mana, current_mana)
			
		"Health":
			base_health += 1
			current_health += 1
			get_tree().call_group("bar_container", "increase_max_value", "Health", base_health, current_health)
			
		"Magic Attack":
			base_magic_attack += 1
			
		"Defense":
			base_defense += 1
			
	update_stats_hud()
	
	
func update_stats_hud() -> void:
	get_tree().call_group(
		"stats_hud", 
		"update_stats", 
		[
			base_health, 
			base_mana,
			base_attack,
			base_magic_attack,
			base_defense
		]
	)
	
	
func update_exp(value: int) -> void:
	current_exp += value
	get_tree().call_group("bar_container", "update_bar", "ExpBar", current_exp)
	
	if current_exp >= level_dict[str(level)] and level < 9:
		get_tree().call_group("stats_hud", "update_avaliable_points")
		var leftover: int = current_exp - level_dict[str(level)]
		current_exp = leftover
		on_level_up()
		level += 1
		
	elif current_exp >= level_dict[str(level)] and level == 9:
		current_exp = level_dict[str(level)]
		
		
func on_level_up() -> void:
	current_mana = base_mana
	current_health = base_health
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
	
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			if current_health >= base_health:
				current_health = base_health
				
		"Decrease":
			verify_shield(value)
			if current_health <= 0:
				player_ref.dead = true
			else:
				player_ref.on_hit = true
				player_ref.attacking = false
				
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	
	
func verify_shield(value: int) -> void:
	if shielding:
		var damage = abs(base_defense - value)
		if damage > 0:
			current_health -= damage
	else:
		current_health -= value
		
		
func update_mana(type: String, value: int) -> void:
	match type:
		"Increase":
			current_mana += value
			if current_mana >= base_mana:
				current_mana = base_mana
				
		"Decrease":
			current_mana -= value
			
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("click"):
		#update_exp(15)
		#update_health("Decrease", 15)
		#update_health("Increase", 5)
		#update_mana("Decrease", 3)
		pass
		
		
func on_collision_area_entered(area):
	if area.name == "AttackArea":
		var enemy_ref: KinematicBody2D = area.get_parent()
		update_health("Decrease", enemy_ref.damage)
		collision_area.set_deferred("monitoring", false)
		invencibility_timer.start(invencibility_time)
		
		
func on_invencibility_timer_timeout() -> void:
	collision_area.set_deferred("monitoring", true)