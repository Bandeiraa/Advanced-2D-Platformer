extends Control
class_name SellContainer

signal closed

onready var buttons_list: Array = [
	get_node("BackButton"),
	get_node("LeftContainerBackground/SellButton")
]

onready var animation: AnimationPlayer = get_node("Animation")

onready var hud_ref: CanvasLayer = get_parent()

onready var left_container: TextureRect = get_node("LeftContainerBackground")
onready var item_texture: TextureRect = left_container.get_node("ItemTexture")

onready var item_amount: Label = left_container.get_node("AmountValue")
onready var item_sell_value: Label = left_container.get_node("SellValue")

onready var scroll_container: ScrollContainer = get_node("RightContainerBackground/Container")
onready var v_container: VBoxContainer = scroll_container.get_node("VContainer")

var sell_value: int = 0
var sell_item_amount: int = 0
var current_item_index: int = -1

func _ready() -> void:
	for button in buttons_list:
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", ["exited", button])
		button.connect("mouse_entered", self, "mouse_interaction", ["entered", button])
		
	for slot in v_container.get_children():
		slot.connect("reset", self, "reset_slot")
		
	get_inventory_data()
	scroll_container.get_v_scrollbar().modulate.a = 0
	
	
func mouse_interaction(state: String, button: TextureButton) -> void:
	match state:
		"entered":
			button.modulate.a = .5
			
		"exited":
			button.modulate.a = 1.0
			
			
func on_button_pressed(button: TextureButton) -> void:
	button.modulate.a = 0.2
	yield(get_tree().create_timer(0.1), "timeout")
	button.modulate.a = 0.5
	
	match button.name:
		"SellButton":
			var inventory_container: GridContainer = hud_ref.get_node("InventoryContainer").slot_container
			inventory_container.get_child(current_item_index).update_amount(sell_item_amount)
			v_container.get_child(current_item_index).update_amount(sell_item_amount)
			GlobalInfo.player_gold += sell_value
			sell_value = 0
			
		"BackButton":
			animation.play("hide_container")
			yield(animation, "animation_finished")
			emit_signal("closed")
			queue_free()
			
			
func get_inventory_data() -> void:
	var inventory_container: GridContainer = hud_ref.get_node("InventoryContainer").slot_container
	for index in inventory_container.get_child_count():
		var slot: TextureRect = inventory_container.get_child(index)
		
		var amount: int = slot.amount
		var item_price: int = slot.sell_price
		var item_image: StreamTexture = slot.get_node("ItemTexture").texture
		
		v_container.get_child(index).update_info(item_price, amount, item_image)
		
		
func reset_slot(index: int, slot_info: Array) -> void:
	for slot in v_container.get_child_count():
		if index == -1:
			buttons_list[1].modulate.a = 1.0
			item_texture.texture = null
			item_sell_value.text = "-"
			buttons_list[1].hide()
			item_amount.text = "-"
			return
			
		if slot != index:
			v_container.get_child(slot).current_selected_item = 0
		else:
			item_amount.text = str(slot_info[0])
			item_sell_value.text = str(slot_info[0] * slot_info[1])
			sell_value = slot_info[0] * slot_info[1]
			item_texture.texture = slot_info[2]
			sell_item_amount = slot_info[0]
			current_item_index = index
			buttons_list[1].show()
