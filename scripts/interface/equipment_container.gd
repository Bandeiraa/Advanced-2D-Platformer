extends Control
class_name EquipmentContainer

onready var animation: AnimationPlayer = get_node("Animation")

onready var consumable_background: TextureRect = get_node("ConsumableBackgroundTexture")
onready var consumable_item: TextureRect = consumable_background.get_node("Item")
onready var consumable_amount: Label = consumable_background.get_node("Amount")

var item_name: String = ""
var item_type: String = ""

var item_price: int
var item_amount: int
var item_type_value: int

var can_click: bool = false

func update_consumable_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if item_info[1] == item_name:
		item_amount += item_info[0]
		
		if item_amount > 9:
			var leftover: int = item_amount - 9
			item_info[0] = leftover
			item_amount = 9
			get_tree().call_group(
				"inventory", 
				"update_slot",
				item_name,
				consumable_item.texture,
				[
					item_type,
					item_type_value,
					item_price,
					leftover
				]
			)
			
			return
			
	elif item_info[1] != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			item_name,
			consumable_item.texture,
			[
				item_type,
				item_type_value,
				item_price,
				item_amount
			]
		)
		
	item_name = item_info[1]
	item_type = item_info[2]
	item_price = item_info[4]
	item_amount = item_info[0]
	item_type_value = item_info[3]
	
	consumable_amount.text = str(item_amount)
	consumable_item.texture = item_texture
	consumable_amount.show()
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		if item_amount > 0:
			match item_type:
				"Health":
					get_tree().call_group("player_stats", "update_health", "Increase", item_type_value)
					get_tree().call_group("player", "spawn_effect", "res://scenes/env/potion_effect.tscn")
					
				"Mana":
					get_tree().call_group("player_stats", "update_mana", "Increase", item_type_value)
					get_tree().call_group("player", "spawn_effect", "res://scenes/env/potion_effect.tscn")
					
			item_amount -= 1
			if item_amount == 0:
				reset()
				
			consumable_amount.text = str(item_amount)
			
			return
			
		reset()
		
		
func on_mouse_entered() -> void:
	can_click = true
	consumable_background.modulate.a = .5
	
	
func on_mouse_exited() -> void:
	can_click = false
	consumable_background.modulate.a = 1.0
	
	
func reset() -> void:
	item_name = ""
	item_type = ""
	item_price = 0
	item_type_value = 0
	consumable_amount.hide()
	consumable_item.texture = null
