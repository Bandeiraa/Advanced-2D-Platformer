extends Control
class_name EquipmentContainer

onready var animation: AnimationPlayer = get_node("Animation")

onready var consumable_container: TextureRect = get_node("ConsumableBackgroundTexture")
onready var armor_container: TextureRect = get_node("VContainer/ArmorBackgroundTexture")
onready var weapon_container: TextureRect = get_node("VContainer/WeaponBackgroundTexture")

func consumable_slot(item_texture: StreamTexture, item_info: Array) -> void:
	consumable_container.update_consumable_slot(item_texture, item_info)
	
	
func armor_slot(item_texture: StreamTexture, item_info: Array) -> void:
	armor_container.update_armor_slot(item_texture, item_info)
	
	
func weapon_slot(item_texture: StreamTexture, item_info: Array) -> void:
	weapon_container.update_weapon_slot(item_texture, item_info)
