extends InteractableTemplate
class_name Ship

onready var aux_animation: AnimationPlayer = get_node("AuxAnimation")

func _ready() -> void:
	set_physics_process(false)
	
	
func on_body_entered(_body: Player) -> void:
	can_interact = false
	aux_animation.play("transition_run")
	
	
func on_screen_exited() -> void:
	if not can_interact:
		print("Outside Screen")
		
		
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"transition_run":
			aux_animation.play("run")
			set_physics_process(true)
			
			
func _physics_process(_delta: float) -> void:
	translate(Vector2.RIGHT)
