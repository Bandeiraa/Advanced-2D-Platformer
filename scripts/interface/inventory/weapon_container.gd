extends TextureRect
class_name WeaponContainer

onready var weapon_item: TextureRect = get_node("Item")

var weapon_dictionary: Dictionary = {}
var weapon_name: String = ""
var weapon_type: String = ""
var weapon_price: int

func update_weapon_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if weapon_name != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			weapon_name,
			weapon_item.texture,
			[
				weapon_type,
				weapon_dictionary,
				weapon_price,
				1
			]
		)
		
		reset()
		
	weapon_item.texture = item_texture
	weapon_name = item_info[0]
	weapon_type = item_info[1]
	weapon_dictionary = item_info[2]
	weapon_price = item_info[3]
	
	weapon_item.show()
	
	get_tree().call_group("stats_hud", "update_bonus_stats", weapon_dictionary, false)
	
	
func reset() -> void:
	weapon_name = ""
	weapon_type = ""
	weapon_price = 0
	
	weapon_item.texture = null
	get_tree().call_group("stats_hud", "update_bonus_stats", weapon_dictionary, true)
	
	weapon_dictionary = {}
