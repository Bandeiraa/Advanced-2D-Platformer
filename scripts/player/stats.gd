extends Node
class_name Stats

onready var invencibility_timer: Timer = get_node("Timer")

var shielding: bool = false

var base_health: int = 15
var base_mana: int = 10
var base_attack: int = 1
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

export(PackedScene) var floating_text

export(NodePath) onready var collision_area = get_node(collision_area) as Area2D
export(NodePath) onready var player_ref = get_node(player_ref) as KinematicBody2D

func _ready() -> void:
	var file = File.new()
	if file.file_exists(DataManagement.save_path):
		persist_data()
		
	if DataManagement.data_dictionary["current_health"] == 0:
		current_mana = base_mana + bonus_mana
		max_mana = current_mana
		
		current_health = base_health + bonus_health
		max_health = current_health
		
		get_tree().call_group("bar_container", "init_bar", max_health, max_mana, level_dict[str(level)])
		
	update_stats_hud()
	
	DataManagement.data_dictionary["current_mana"] = current_mana
	DataManagement.data_dictionary["current_health"] = current_health
	DataManagement.save_data()
	
	
func persist_data() -> void:
	DataManagement.load_data()
	level = DataManagement.data_dictionary["level"]
	current_exp = DataManagement.data_dictionary["current_exp"]
	
	print("Nível atual: " + str(level))
	print("Ouro atual: " + str(DataManagement.data_dictionary["player_gold"]))
	print("Exp atual: " + str(current_exp) + "/" + str(level_dict[str(level)]))
	
	get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
	
	if not DataManagement.data_dictionary["base_stats"].empty():
		base_health = DataManagement.data_dictionary["base_stats"][0]
		base_mana = DataManagement.data_dictionary["base_stats"][1]
		base_attack = DataManagement.data_dictionary["base_stats"][2]
		base_magic_attack = DataManagement.data_dictionary["base_stats"][3]
		base_defense = DataManagement.data_dictionary["base_stats"][4]
		
		max_mana = base_mana
		max_health = base_health
		
		current_mana = DataManagement.data_dictionary["current_mana"]
		current_health = DataManagement.data_dictionary["current_health"]
		
		print("Vida atual: " + str(current_health))
		print("Mana atual: " + str(current_mana))
		
		get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
		get_tree().call_group("bar_container", "increase_max_value", "Health", max_health, current_health)
		
		
func update_stats(stat: String) -> void:
	match stat:
		"Attack":
			base_attack += 1
			
		"Mana":
			max_mana += 1
			base_mana += 1
			current_mana += 1
			DataManagement.data_dictionary["current_mana"] = current_mana
			DataManagement.save_data()
			
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
			
		"Health":
			max_health += 1
			base_health += 1
			current_health += 1
			DataManagement.data_dictionary["current_health"] = current_health
			DataManagement.save_data()
			
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
	
	DataManagement.data_dictionary["base_stats"] = [
		base_health,
		base_mana,
		base_attack,
		base_magic_attack,
		base_defense
	]
	
	DataManagement.save_data()
	
	
func update_exp(value: int) -> void:
	current_exp += value
	spawn_floating_text("+", "Exp", value)
	get_tree().call_group("bar_container", "update_bar", "ExpBar", current_exp)
	
	if current_exp >= level_dict[str(level)] and level < 9:
		var leftover: int = current_exp - level_dict[str(level)]
		current_exp = leftover
		on_level_up()
		level += 1
		DataManagement.data_dictionary["level"] = level
		
	elif current_exp >= level_dict[str(level)] and level == 9:
		current_exp = level_dict[str(level)]
		
	DataManagement.data_dictionary["current_exp"] = current_exp
	DataManagement.save_data()
	
	
func on_level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_health = base_health + bonus_health
	
	DataManagement.data_dictionary["current_mana"] = current_mana
	DataManagement.data_dictionary["current_health"] = current_health
	DataManagement.save_data()
	
	get_tree().call_group("stats_hud", "update_avaliable_points")
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
	
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			spawn_floating_text("+", "Heal", value)
			if current_health >= max_health:
				current_health = max_health
				
		"Decrease":
			verify_shield(value)
			if current_health <= 0:
				DataManagement.data_dictionary["armor_container"] = []
				DataManagement.data_dictionary["weapon_container"] = []
				DataManagement.data_dictionary["consumable_container"] = []
				DataManagement.data_dictionary["current_health"] = base_health
				DataManagement.data_dictionary["current_mana"] = base_mana
				DataManagement.save_data()
				
				player_ref.dead = true
				get_tree().call_group("inventory", "reset_inventory")
				
			else:
				player_ref.on_hit = true
				player_ref.attacking = false
				
	if not player_ref.dead:
		DataManagement.data_dictionary["current_health"] = current_health
		DataManagement.save_data()
		
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	
	
func verify_shield(value: int) -> void:
	if shielding:
		if (base_defense + bonus_defense) > value:
			return
			 
		var damage = abs((base_defense + bonus_defense) - value)
		if damage > 0:
			current_health -= damage
			spawn_floating_text("-", "Damage", damage)
			
	else:
		current_health -= value
		spawn_floating_text("-", "Damage", value)
		
		
func update_mana(type: String, value: int) -> void:
	match type:
		"Increase":
			current_mana += value
			spawn_floating_text("+", "Mana", value)
			if current_mana >= base_mana:
				current_mana = base_mana
				
		"Decrease":
			spawn_floating_text("-", "Mana", value)
			current_mana -= value
			
	if not player_ref.dead:
		DataManagement.data_dictionary["current_mana"] = current_mana
		DataManagement.save_data()
		
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	
	
func on_collision_area_entered(area):
	if area.name == "AttackArea":
		var enemy_ref: KinematicBody2D = area.get_parent()
		update_health("Decrease", enemy_ref.damage)
		collision_area.set_deferred("monitoring", false)
		invencibility_timer.start(area.get_parent().attack_cooldown)
		
		
func on_invencibility_timer_timeout() -> void:
	collision_area.set_deferred("monitoring", true)
	
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatText = floating_text.instance()
	text.rect_global_position = player_ref.global_position
	
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	get_tree().root.call_deferred("add_child", text)
