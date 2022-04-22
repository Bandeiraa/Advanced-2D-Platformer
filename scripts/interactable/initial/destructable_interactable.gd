extends Area2D
class_name DestructableInteractable

const FLOATING_TEXT: PackedScene = preload("res://scenes/env/floating_text.tscn")
const SLICE: PackedScene = preload("res://scenes/env/slice.tscn")

onready var timer: Timer = get_node("Timer")
onready var animation: AnimationPlayer = get_node("Animation")

export(int) var health
export(float) var invulnerability_timer

func on_area_entered(area) -> void:
	if area.get_parent() is Player:
		var player_stats: Node = area.get_parent().get_node("Stats")
		var player_attack: int = player_stats.base_attack + player_stats.bonus_attack
		update_health(player_attack)
	elif area is FireSpell:
		update_health(area.spell_damage)
		set_deferred("monitoring", false)
		timer.start(invulnerability_timer)
		
		
func update_health(damage: int) -> void:
	health -= damage
	animation.play("hit")
	spawn_floating_text("-", "Damage", damage)
	
	if health <= 0: 
		spawn()
		queue_free()
		return
		
		
func on_timer_timeout() -> void:
	set_deferred("monitoring", true)
	
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatText = FLOATING_TEXT.instance()
	get_tree().root.call_deferred("add_child", text)
	
	text.rect_global_position = global_position
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	
func spawn() -> void:
	pass
	
	
func on_animation_finished(_anim_name: String) -> void:
	pass
