extends TextureRect

signal empty_slot
signal item_clicked

onready var item_texture: TextureRect = get_node("ItemTexture")
onready var item_amount: Label = get_node("Amount")
onready var item_index: int = get_index()

var type_value: int
var sell_price: int
 
var amount: int = 0

var can_click: bool = false

var item_dictionary: Dictionary = {}

var item_name: String = ""
var item_type: String

var texture_list: Array = [
	"res://assets/interface/intentory/item_background/type_1.png",
	"res://assets/interface/intentory/item_background/type_2.png",
	"res://assets/interface/intentory/item_background/type_3.png"
]

func _ready() -> void:
	randomize()
	var random_index: int = randi() % texture_list.size()
	texture = load(texture_list[random_index])
	
	
func on_mouse_entered():
	can_click = true
	modulate.a = 0.5
	
	
func on_mouse_exited() -> void:
	can_click = false
	modulate.a = 1.0
	
	
func update_item(item: String, item_image: StreamTexture, item_info: Array) -> void:
	item_type = item_info[0]
	match item_type:
		"Equipment":
			amount = 1
			item_dictionary = item_info[1]
			
		"Resource":
			amount += item_info[3]
			type_value = 0
			
		"Health":
			amount += item_info[3]
			type_value = item_info[1]
			
		"Mana":
			amount += item_info[3]
			type_value = item_info[1]
			
	sell_price = item_info[2]
	
	item_name = item
	item_amount.text = str(amount)
	item_texture.texture = item_image
	
	if amount != 0 and item_type != "Equipment":
		item_amount.show()
		item_texture.show()
	elif item_type == "Equipment":
		item_texture.show()
		
		
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click and item_name != "":
		emit_signal("item_clicked", item_index)
		
		modulate.a = 0.2
		yield(get_tree().create_timer(0.1), "timeout")
		modulate.a = 0.5
		
		
func equip_item() -> void:
	if item_type == "Health" or item_type == "Mana":
		get_tree().call_group(
			"equipment_container", 
			"update_consumable_slot", 
			item_texture.texture, 
			[
				amount,
				item_name,
				item_type,
				type_value,
				sell_price
			]
		)
		
	elif item_type == "Equipment":
		get_tree().call_group(
			"equipment_container",
			"update_equipment_slot",
			item_texture.texture,
			[
				item_name,
				item_type,
				item_dictionary,
				sell_price
			]
		)
		
	elif item_type == "Resource":
		return
		
	update_slot()
	
	
func update_slot() -> void:
	item_amount.hide()
	item_texture.hide()
	
	amount = 0
	
	item_name = ""
	item_type = ""
	type_value = 0
	sell_price = 0

	emit_signal("empty_slot", item_index)
	
	
func update_amount(value: int) -> void:
	var new_amount: int = amount - value
	if new_amount == 0:
		update_slot()
		
		
func reset() -> void:
	modulate.a = 1.0
	can_click = false
