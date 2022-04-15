extends InteractableTemplate
class_name Checkpoint

var dialog_list: Dictionary = {
	"name": null,
	"portrait": null,
	"choice": false
}

export(Vector2) var checkpoint_spawn_position

export(Array, String, MULTILINE) var list

func _ready() -> void:
	dialog_list["dialog"] = list
	
	
func interactable_action() -> void:
	get_tree().call_group("hud", "spawn_dialog", self, dialog_list)
	dialog_icon_animation.play("hide_container")
	player_ref.reset(true)
	
	
func on_dialog_finished() -> void:
	can_interact = true
	player_ref.reset(false)
	dialog_icon_animation.play("show_container")
	get_tree().call_group("hud", "normal_state")

	DataManagement.data_dictionary["checkpoint"] = true
	DataManagement.data_dictionary["player_position"] = checkpoint_spawn_position
	DataManagement.save_data()
