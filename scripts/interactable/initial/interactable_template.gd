extends Area2D
class_name InteractableTemplate

onready var dialog_icon: AnimatedSprite = get_node("DialogIcon")
onready var dialog_icon_animation: AnimationPlayer = dialog_icon.get_node("Animation")

var player_ref: KinematicBody2D = null
var can_interact: bool = true

func on_body_entered(body: Player) -> void:
	player_ref = body
	dialog_icon_animation.play("show_container")
	
	
func on_body_exited(_body: Player) -> void:
	player_ref = null
	if dialog_icon.modulate.a != 0:
		dialog_icon_animation.play("hide_container")
		
		
func _process(_delta: float) -> void:
	if player_ref != null and Input.is_action_just_pressed("interact") and player_ref.is_on_floor() and can_interact:
		interactable_action()
		can_interact = false
		
		
func interactable_action() -> void:
	pass
