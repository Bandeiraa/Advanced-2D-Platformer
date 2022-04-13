extends TextureRect
class_name RightSellContainer

onready var scroll_container: ScrollContainer = get_node("Container")
onready var v_container: VBoxContainer = scroll_container.get_node("HContainer/VContainer")

export(NodePath) onready var sell_button = get_node(sell_button) as TextureButton
export(NodePath) onready var left_container = get_node(left_container) as TextureRect
export(NodePath) onready var sell_container = get_node(sell_container) as Control

func _ready() -> void:
	for slot in v_container.get_children():
		slot.connect("reset", self, "reset_slot")
		
		
func reset_slot(index: int, slot_info: Array) -> void:
	for slot in v_container.get_child_count():
		if index == -1:
			reset_sell_container()
			return
			
		if slot != index:
			v_container.get_child(slot).current_selected_item = 0
		else:
			update_sell_container(index, slot_info)
			
			
func reset_sell_container() -> void:
	sell_button.modulate.a = 1.0
	sell_button.hide()
	left_container.reset_info()
	
	
func update_sell_container(index: int, slot_info: Array) -> void:
	left_container.show_info(slot_info)
	sell_container.current_item_index = index
	sell_button.show()
	
	
func update_slot_amount(item_index: int, item_amount: int) -> void:
	v_container.get_child(item_index).update_amount(item_amount)
	
	
func update_slot(index: int, price: int, amount: int, image: StreamTexture) -> void:
	v_container.get_child(index).update_info(price, amount, image)
