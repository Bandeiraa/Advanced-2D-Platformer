extends Node

var save_path: String = "user://save.dat"

var data_dictionary = {
	"level": 1,
	"current_exp": 0,
	"player_gold": 0,
	"base_stats": [15, 10, 10, 3, 1],
	"bonus_stats": [0, 0, 0, 0, 0],
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
