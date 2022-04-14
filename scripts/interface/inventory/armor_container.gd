extends TextureRect
class_name ArmorContainer

onready var armor_item: TextureRect = get_node("Item")

var armor_dictionary: Dictionary = {}
var armor_name: String = ""
var armor_type: String = ""
var armor_price: int

func update_armor_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if armor_name != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			armor_name,
			armor_item.texture,
			[
				armor_type,
				armor_dictionary,
				armor_price,
				1
			]
		)
		
		reset()
		
	armor_item.texture = item_texture
	armor_name = item_info[0]
	armor_type = item_info[1]
	armor_dictionary = item_info[2]
	armor_price = item_info[3]
	
	armor_item.show()
	
	get_tree().call_group("stats_hud", "update_bonus_stats", armor_dictionary, false)
	
	
func reset() -> void:
	armor_name = ""
	armor_type = ""
	armor_price = 0
	
	armor_item.texture = null
	get_tree().call_group("stats_hud", "update_bonus_stats", armor_dictionary, true)
	
	armor_dictionary = {}
