extends HBoxContainer
class_name SellItemContainer

signal reset

onready var item_icon: TextureRect = get_node("ItemIcon")
onready var buttons_list: Array = [
	get_node("LeftContainer/Minos"),
	get_node("RightContainer/Plus")
]

onready var item_index: int = get_index()

var current_selected_item: int = 0

var item_price: int
var total_amount: int

func _ready() -> void:
	for button in buttons_list:
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", ["exited", button])
		button.connect("mouse_entered", self, "mouse_interaction", ["entered", button])
		
		
func mouse_interaction(state: String, button: TextureButton) -> void:
	match state:
		"entered":
			button.modulate.a = .5
			
		"exited":
			button.modulate.a = 1.0
			
			
func on_button_pressed(button: TextureButton) -> void:
	match button.name:
		"Minos":
			if current_selected_item > 0:
				current_selected_item -= 1
				if current_selected_item == 0:
					emit_signal("reset", -1, [current_selected_item, item_price, item_icon.texture])
				else:
					emit_signal("reset", item_index, [current_selected_item, item_price, item_icon.texture])
				
				reset(button)
				
		"Plus":
			if current_selected_item < total_amount:
				current_selected_item += 1
				emit_signal("reset", item_index, [current_selected_item, item_price, item_icon.texture])
				reset(button)
				
				
func reset(button: TextureButton) -> void:
	button.modulate.a = 0.2
	yield(get_tree().create_timer(0.1), "timeout")
	button.modulate.a = 0.5
	
	
func update_info(price: int, amount: int, item_image: StreamTexture) -> void:
	item_price = price
	total_amount = amount
	item_icon.texture = item_image
	
	if total_amount != 0:
		show()
		
		
func update_amount(selled_amount: int) -> void:
	var new_amount: int = total_amount - selled_amount
	current_selected_item = 0
	total_amount = new_amount
	if total_amount == 0:
		hide()
		
	emit_signal("reset", -1, [current_selected_item, item_price, item_icon.texture])
