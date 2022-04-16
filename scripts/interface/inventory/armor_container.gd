extends TextureRect
class_name ArmorContainer

onready var armor_item: TextureRect = get_node("Item")

var armor_dictionary: Dictionary = {}
var armor_name: String = ""
var armor_type: String = ""
var armor_texture_path: String = ""

var armor_price: int

func _ready() -> void:
	var file = File.new()
	if file.file_exists(DataManagement.save_path) and not DataManagement.data_dictionary["armor_container"].empty():
		var list: Array = DataManagement.data_dictionary["armor_container"]
		var serialized_texture: StreamTexture = load(list[0])
		var serialized_list: Array = [list[0], list[1], list[2], list[3], list[4]]
		update_armor_slot(serialized_texture, serialized_list)
		
		
func update_armor_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if armor_name != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			armor_name,
			armor_item.texture,
			[
				armor_texture_path,
				armor_type,
				armor_dictionary,
				armor_price,
				1
			]
		)
		
		reset()
		
	armor_item.texture = item_texture
	armor_texture_path = item_info[0]
	armor_name = item_info[1]
	armor_type = item_info[2]
	armor_dictionary = item_info[3]
	armor_price = item_info[4]
	
	armor_item.show()
	
	DataManagement.data_dictionary["armor_container"] = item_info
	DataManagement.save_data()
	
	get_tree().call_group("stats_hud", "update_bonus_stats", armor_dictionary, false)
	
	
func reset() -> void:
	armor_name = ""
	armor_type = ""
	armor_texture_path = ""
	
	armor_price = 0
	
	armor_item.texture = null
	get_tree().call_group("stats_hud", "update_bonus_stats", armor_dictionary, true)
	
	armor_dictionary = {}
