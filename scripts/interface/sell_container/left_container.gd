extends TextureRect
class_name LeftSellContainer

onready var item_texture: TextureRect = get_node("ItemTexture")
onready var item_sell_value: Label = get_node("SellValue")
onready var item_amount: Label = get_node("AmountValue")

export(NodePath) onready var sell_container = get_node(sell_container) as Control

func reset_info() -> void:
	item_texture.texture = null
	item_sell_value.text = "-"
	item_amount.text = "-"
	
	
func show_info(slot_info: Array) -> void:
	var amount: int = slot_info[0]
	var sell_value: int = slot_info[0] * slot_info[1]
	
	item_amount.text = str(amount)
	item_texture.texture = slot_info[2]
	item_sell_value.text = str(sell_value)
	
	sell_container.sell_value = sell_value
	sell_container.sell_item_amount = amount
