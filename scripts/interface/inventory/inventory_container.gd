extends Control
class_name InventoryContainer

onready var slot_container: GridContainer = get_node("VContainer/Background/SlotContainer")
onready var animation: AnimationPlayer = get_node("Animation")

onready var aux_container: TextureRect = get_node("Container")
onready var aux_animation: AnimationPlayer = aux_container.get_node("Animation")
onready var aux_h_container: HBoxContainer = aux_container.get_node("HContainer")

var current_state: String
var can_click: bool = false
var is_visible: bool = false

var item_index: int

var slot_item_info: Array = [
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
	DataManagement.load_data()
	if DataManagement.data_dictionary["inventory"].empty():
		DataManagement.data_dictionary["inventory"] = slot_list
		DataManagement.data_dictionary["aux_inventory"] = slot_item_info
		DataManagement.save_data()
		
	populate_inventory()
	
	for icon in aux_h_container.get_children():
		icon.connect("mouse_exited", self, "mouse_interaction", ["exited", icon])
		icon.connect("mouse_entered", self, "mouse_interaction", ["entered", icon])
		
	for children in slot_container.get_children():
		children.connect("empty_slot", self, "empty_slot")
		children.connect("item_clicked", self, "on_item_clicked")
		
		
func populate_inventory() -> void:
	for index in DataManagement.data_dictionary["inventory"].size():
		slot_list[index] = DataManagement.data_dictionary["inventory"][index]
		slot_item_info[index] = DataManagement.data_dictionary["aux_inventory"][index]
		if DataManagement.data_dictionary["inventory"][index] != "":
			var slot_info_list: Array = slot_item_info[index][2]
			slot_container.get_child(index).update_item(
				slot_list[index], 
				load(slot_info_list[0]), 
				slot_info_list
			)
			
			
func update_slot(item_name: String, item_image: StreamTexture, item_info: Array) -> void:
	var existing_item_index: int = slot_list.find(item_name)
	if existing_item_index != -1:
		var item_slot: TextureRect = slot_container.get_child(existing_item_index)
		if item_slot.amount < 9 and item_slot.item_type != "Equipment" and item_slot.item_type != "Weapon":
			var current_amount: int = item_slot.amount + item_info[3]
			if current_amount > 9:
				var leftover: int = current_amount - 9
				item_info[3] = 9 - item_slot.amount
				slot_container.get_child(existing_item_index).update_item(item_name, item_image, item_info)
				item_info[3] = leftover
				update_slot(item_name, item_image, item_info)
				return
				
			slot_container.get_child(existing_item_index).update_item(item_name, item_image, item_info)
			return
			
	var aux_item_index: int = slot_list.find_last(item_name)
	if aux_item_index != -1:
		var item_slot: TextureRect = slot_container.get_child(aux_item_index)
		if item_slot.amount < 9 and item_slot.item_type != "Equipment" and item_slot.item_type != "Weapon":
			slot_container.get_child(aux_item_index).update_item(item_name, item_image, item_info)
			return
			
	for index in slot_container.get_child_count():
		var slot: TextureRect = slot_container.get_child(index)
		if slot.item_name == "":
			slot_list[index] = item_name
			slot_item_info[index] = [item_name, item_image, item_info]
			slot.update_item(item_name, item_image, item_info)
			return
			
			
func empty_slot(index: int) -> void:
	slot_list[index] = ""
	slot_item_info[index] = ""
	DataManagement.data_dictionary["inventory"][index] = ""
	DataManagement.data_dictionary["aux_inventory"][index] = ""
	DataManagement.save_data()
	
	
func reset_inventory() -> void:
	for index in slot_list.size():
		empty_slot(index)
		
		
func reset() -> void:
	item_index = -1
	can_click = false
	current_state = ""
	aux_animation.play("hide_container")
	for children in slot_container.get_children():
		children.reset()
		
		
func on_item_clicked(index: int) -> void:
	aux_animation.play("show_container")
	item_index = index
	
	
func mouse_interaction(state: String, object: TextureRect) -> void:
	match state:
		"entered":
			can_click = true
			object.modulate.a = .5
			current_state = object.name
			
		"exited":
			current_state = ""
			can_click = false
			object.modulate.a = 1.0
			
			
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click and current_state != "":
		match current_state:
			"Equip":
				slot_container.get_child(item_index).equip_item()
				
			"Delete":
				slot_container.get_child(item_index).update_slot()
				
		item_index = -1
		current_state = ""
		aux_animation.play("hide_container")
