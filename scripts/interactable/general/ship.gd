extends InteractableTemplate
class_name Ship

onready var aux_animation: AnimationPlayer = get_node("AuxAnimation")
onready var camera: Camera2D = get_node("Camera")
onready var tween: Tween = get_node("Tween")

export(String) var target_level

func _ready() -> void:
	set_physics_process(false)
	
	
func on_body_entered(body: Player) -> void:
	body.hide_player()
	can_interact = false
	interpolate_camera(body.camera)
	aux_animation.play("transition_run")
	
	
func _physics_process(_delta: float) -> void:
	translate(Vector2.RIGHT)
	
	
func interpolate_camera(player_camera: Camera2D) -> void:
	var _camera_position: bool = tween.interpolate_property(
		player_camera,
		"global_position",
		player_camera.global_position,
		camera.global_position,
		1.0,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	var _start: bool = tween.start()
	
	yield(tween, "tween_all_completed")
	
	get_tree().call_group("hud", "hide_containers")
	set_physics_process(true)
	aux_animation.play("run")
	camera.current = true
	
	yield(get_tree().create_timer(3.0), "timeout")
	TransitionScreen.fade_in(target_level, true)
