extends Node

var save_path: String = "user://save.dat"

var data_dictionary = {
	"level": 1,
	"player_gold": 0,
	"current_exp": 0,
	"stats_points": 0,
	"current_health": 0,
	
	"base_stats": [],
	"armor_container": [],
	"weapon_container": [],
	"consumable_container": [],
	
	"sign_checkpoint": false,
	"checkpoint": false,
	"player_texture": "",
	"player_position": Vector2(-882, 132)
}

func save_data() -> void:
	var file: File = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data_dictionary)
		file.close()
		
		
func load_data() -> void:
	var file: File = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			data_dictionary = file.get_var()
			file.close()
