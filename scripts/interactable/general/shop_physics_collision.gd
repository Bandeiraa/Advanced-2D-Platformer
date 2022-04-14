extends StaticBody2D

onready var physics_collision: CollisionShape2D = get_node("Collision")

var player_ref: KinematicBody2D = null

func on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body
		
		
func on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null
		physics_collision.set_deferred("disabled", false)
		
		
func _process(_delta: float) -> void:
	if player_ref != null and player_ref.crouching:
		physics_collision.set_deferred("disabled", true)
