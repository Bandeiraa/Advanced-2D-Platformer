extends Sprite
class_name EnemyTexture

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var enemy_ref = get_node(enemy_ref) as KinematicBody2D

func animate(_velocity: Vector2) -> void:
	pass
	
	
func on_animation_finished(_anim_name: String) -> void:
	pass
