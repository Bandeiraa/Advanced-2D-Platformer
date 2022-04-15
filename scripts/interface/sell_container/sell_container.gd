extends Control
class_name SellContainer

signal closed

onready var right_container: TextureRect = get_node("RightContainerBackground")
onready var animation: AnimationPlayer = get_node("Animation")
onready var hud_ref = get_parent()

onready var buttons_list: Array = [
	get_node("BackButton"),
	get_node("SellButton")
]

var sell_value: int = 0
var sell_item_amount: int = 0
var current_item_index: int = -1

func _ready() -> void:
	for button in buttons_list:
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", ["exited", button])
		button.connect("mouse_entered", self, "mouse_interaction", ["entered", button])
		
	get_inventory_data()
	
	
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
			right_container.update_slot_amount(current_item_index, sell_item_amount)
			DataManagement.data_dictionary["player_gold"] += sell_value
			DataManagement.save_data()
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
		
		right_container.update_slot(index, item_price, amount, item_image)
