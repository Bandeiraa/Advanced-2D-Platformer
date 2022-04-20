extends EnemyTexture
class_name CrabbyTexture

const ATTACK_EFFECT: PackedScene = preload("res://scenes/effect/general_effect/crabby_attack_effect.tscn")

func animate(velocity: Vector2) -> void:
	if enemy_ref.can_attack or enemy_ref.can_hit or enemy_ref.can_die:
		action_behavior()
	else:
		move_behavior(velocity)
		
		
func action_behavior() -> void:
	if enemy_ref.can_die:
		animation.play("dead")
		enemy_ref.can_hit = false
		enemy_ref.can_attack = false
		attack_area_collision.set_deferred("disabled", true)
		
	elif enemy_ref.can_hit:
		animation.play("hit")
		enemy_ref.can_attack = false
		attack_area_collision.set_deferred("disabled", true)
		
	elif enemy_ref.can_attack:
		animation.play("attack" + enemy_ref.attack_animation_suffix)
		
		
func move_behavior(velocity: Vector2) -> void:
	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
		
		
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"attack_left":
			enemy_ref.can_attack = false
			enemy_ref.set_physics_process(true)
			
		"attack_right":
			enemy_ref.can_attack = false
			enemy_ref.set_physics_process(true)
			
		"hit":
			enemy_ref.can_hit = false
			enemy_ref.can_attack = false
			enemy_ref.set_physics_process(true)
			
		"dead":
			enemy_ref.kill_enemy()
			enemy_ref.can_attack = false
			
		"kill":
			enemy_ref.queue_free()
			
			
func spawn_attack_effect() -> void:
	var effect = ATTACK_EFFECT.instance()
	get_tree().root.call_deferred("add_child", effect)
	effect.global_position = global_position
	effect.play_effect()
