extends InteractableTemplate
class_name InitialCheckpoint

var dialog_list: Dictionary = {
	"name": null,
	"portrait": null,
	"choice": false
}

export(Vector2) var checkpoint_spawn_position
export(Array, String, MULTILINE) var list

func _ready() -> void:
	dialog_list["dialog"] = list
	
	
func on_dialog_finished() -> void:
	player_ref.reset(true)
	dialog_icon_animation.play("show_container")
	get_tree().call_group("hud", "normal_state")
	
	GlobalInfo.checkpoint = true
	GlobalInfo.checkpoint_position = checkpoint_spawn_position
	
	
func interactable_action() -> void:
	get_tree().call_group("hud", "spawn_dialog", self, dialog_list)
	dialog_icon_animation.play("hide_container")
	player_ref.reset(false)
	
	
func on_body_exited(_body: Player) -> void:
	player_ref = null
	can_interact = true
	if dialog_icon.modulate.a != 0:
		dialog_icon_animation.play("hide_container")
		
		
func _process(_delta: float) -> void:
	if player_ref != null and player_ref.is_on_floor() and can_interact:
		interactable_action()
		can_interact = false
