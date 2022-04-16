extends TextureRect
class_name ConsumableContainer

onready var consumable_item: TextureRect = get_node("Item")
onready var consumable_amount: Label = get_node("Amount")

var consumable_item_name: String = ""
var consumable_item_type: String = ""
var consumable_texture_path: String = ""

var consumable_item_price: int
var consumable_item_amount: int
var consumable_item_type_value: int

var can_click: bool = false

func _ready() -> void:
	var file = File.new()
	if file.file_exists(DataManagement.save_path) and not DataManagement.data_dictionary["consumable_container"].empty():
		var list: Array = DataManagement.data_dictionary["consumable_container"]
		var serialized_texture: StreamTexture = load(list[0])
		var serialized_list: Array = [list[0], list[1], list[2], list[3], list[4], list[5]]
		update_consumable_slot(serialized_texture, serialized_list)
		
		
func update_consumable_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if item_info[2] == consumable_item_name:
		consumable_item_amount += item_info[1]
		
		if consumable_item_amount > 9:
			var leftover: int = consumable_item_amount - 9
			item_info[1] = leftover
			consumable_item_amount = 9
			get_tree().call_group(
				"inventory", 
				"update_slot",
				consumable_item_name,
				consumable_item.texture,
				[
					consumable_texture_path,
					consumable_item_type,
					consumable_item_type_value,
					consumable_item_price,
					leftover
				]
			)
			
		consumable_amount.text = str(consumable_item_amount)
		return
		
	elif consumable_item_name != "": #item_info[1] != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			consumable_item_name,
			consumable_item.texture,
			[
				consumable_texture_path,
				consumable_item_type,
				consumable_item_type_value,
				consumable_item_price,
				consumable_item_amount
			]
		)
		
	consumable_texture_path = item_info[0]
	consumable_item_amount = item_info[1]
	consumable_item_name = item_info[2]
	consumable_item_type = item_info[3]
	consumable_item_type_value = item_info[4]
	consumable_item_price = item_info[5]
	
	consumable_amount.text = str(consumable_item_amount)
	consumable_item.texture = item_texture
	consumable_amount.show()
	
	DataManagement.data_dictionary["consumable_container"] = item_info
	DataManagement.save_data()
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		if consumable_item_amount > 0:
			match consumable_item_type:
				"Health":
					get_tree().call_group("player_stats", "update_health", "Increase", consumable_item_type_value)
					get_tree().call_group("player", "spawn_effect", "res://scenes/effect/potion_effect.tscn")
					
				"Mana":
					get_tree().call_group("player_stats", "update_mana", "Increase", consumable_item_type_value)
					get_tree().call_group("player", "spawn_effect", "res://scenes/effect/potion_effect.tscn")
					
			consumable_item_amount -= 1
			
			DataManagement.data_dictionary["consumable_container"] = [
				consumable_texture_path,
				consumable_item_amount,
				consumable_item_name,
				consumable_item_type,
				consumable_item_type_value,
				consumable_item_price
			]
			
			DataManagement.save_data()
			
			if consumable_item_amount == 0:
				reset()
				
			consumable_amount.text = str(consumable_item_amount)
			
			return
			
		reset()
		
		
func on_mouse_entered() -> void:
	can_click = true
	modulate.a = .5
	
	
func on_mouse_exited() -> void:
	can_click = false
	modulate.a = 1.0
	
	
func reset() -> void:
	consumable_item_name = ""
	consumable_item_type = ""
	consumable_texture_path = ""
	
	consumable_item_price = 0
	consumable_item_type_value = 0
	
	consumable_amount.hide()
	consumable_item.texture = null
	
	DataManagement.data_dictionary["consumable_container"] = []
	DataManagement.save_data()
