extends Control
class_name InventoryContainer

onready var slot_container: GridContainer = get_node("VContainer/Background/SlotContainer")
onready var animation: AnimationPlayer = get_node("Animation")

var is_visible: bool = false

var slot_list: Array = [
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
]

func _ready() -> void:
	for children in slot_container.get_children():
		children.connect("empty_slot", self, "empty_slot")
		
		
func update_slot(item_name: String, item_image: StreamTexture, item_info: Array) -> void:
	var existing_item_index: int = slot_list.find(item_name)
	if existing_item_index != -1:
		if slot_container.get_child(existing_item_index).amount < 9:
			var slot_amount: int = slot_container.get_child(existing_item_index).amount
			var current_amount: int = slot_amount + item_info[3]
			if current_amount > 9:
				var leftover: int = current_amount - 9
				item_info[3] = 9 - slot_amount
				slot_container.get_child(existing_item_index).update_item(item_name, item_image, item_info)
				item_info[3] = leftover
				update_slot(item_name, item_image, item_info)
				return
				
			slot_container.get_child(existing_item_index).update_item(item_name, item_image, item_info)
			return
			
	var aux_item_index: int = slot_list.find_last(item_name)
	if aux_item_index != -1:
		if slot_container.get_child(aux_item_index).amount < 9:
			slot_container.get_child(aux_item_index).update_item(item_name, item_image, item_info)
			return
			
	for index in slot_container.get_child_count():
		var slot: TextureRect = slot_container.get_child(index)
		if slot.item_name == "":
			slot_list[index] = item_name
			slot.update_item(item_name, item_image, item_info)
			return
			
			
func empty_slot(index: int) -> void:
	slot_list[index] = ""
	
	
func reset() -> void:
	for children in slot_container.get_children():
		children.reset()
