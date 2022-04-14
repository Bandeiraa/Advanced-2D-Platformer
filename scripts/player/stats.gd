extends Node
class_name Stats

onready var invencibility_timer: Timer = get_node("Timer")

var shielding: bool = false

var base_health: int = 15
var base_mana: int = 10
var base_attack: int = 10
var base_magic_attack: int = 3
var base_defense: int = 1

var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0
var bonus_magic_attack: int = 0
var bonus_defense: int = 0

var current_mana: int
var current_health: int

var max_mana: int
var max_health: int

var current_exp: int = 0

var level: int = 1
var level_dict: Dictionary = {
	"1": 25,
	"2": 33,
	"3": 49,
	"4": 66,
	"5": 93,
	"6": 135,
	"7": 186,
	"8": 251,
	"9": 356
}

export(float) var invencibility_time

export(NodePath) onready var collision_area = get_node(collision_area) as Area2D
export(NodePath) onready var player_ref = get_node(player_ref) as KinematicBody2D

func _ready() -> void:
	update_stats_hud()
	
	current_mana = base_mana + bonus_mana
	max_mana = current_mana
	
	current_health = base_health + bonus_health
	max_health = current_health
	
	get_tree().call_group("bar_container", "init_bar", max_health, max_mana, level_dict[str(level)])
	
	
func update_stats(stat: String) -> void:
	match stat:
		"Attack":
			base_attack += 1
			
		"Mana":
			max_mana += 1
			base_mana += 1
			current_mana += 1
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
			
		"Health":
			max_health += 1
			base_health += 1
			current_health += 1
			get_tree().call_group("bar_container", "increase_max_value", "Health", max_health, current_health)
			
		"Magic Attack":
			base_magic_attack += 1
			
		"Defense":
			base_defense += 1
			
	update_stats_hud()
	
	
func update_bonus_stats(stat: String, value: int, reset: bool) -> void:
	match stat:
		"Health":
			if reset:
				bonus_health -= value
				current_health -= value
			else:
				bonus_health += value
				current_health += bonus_health
				
			max_health = bonus_health + base_health
			get_tree().call_group("bar_container", "increase_max_value", "Health", max_health, current_health)
			
		"Mana":
			if reset:
				bonus_mana -= value
				current_mana -= value
			else:
				bonus_mana += value
				current_mana += bonus_mana
				
			max_mana = bonus_mana + base_mana
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
			
		"Attack":
			if reset:
				bonus_attack -= value
			else:
				bonus_attack += value
				
		"Magic Attack":
			if reset:
				bonus_magic_attack -= value
			else:
				bonus_magic_attack += value
				
		"Defense":
			if reset:
				bonus_defense -= value
			else:
				bonus_defense += value
				
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
		],
		[
			bonus_health,
			bonus_mana,
			bonus_attack,
			bonus_magic_attack,
			bonus_defense
		]
	)
	
	
func update_exp(value: int) -> void:
	current_exp += value
	get_tree().call_group("bar_container", "update_bar", "ExpBar", current_exp)
	
	if current_exp >= level_dict[str(level)] and level < 9:
		var leftover: int = current_exp - level_dict[str(level)]
		current_exp = leftover
		on_level_up()
		level += 1
		
	elif current_exp >= level_dict[str(level)] and level == 9:
		current_exp = level_dict[str(level)]
		
		
func on_level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_health = base_health + bonus_health
	
	get_tree().call_group("stats_hud", "update_avaliable_points")
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
	
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			if current_health >= max_health:
				current_health = max_health
				
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
		if (base_defense + bonus_defense) > value:
			return
			 
		var damage = abs((base_defense + bonus_defense) - value)
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
