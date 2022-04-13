extends Control
class_name EquipmentContainer

onready var animation: AnimationPlayer = get_node("Animation")

onready var equipment_background: TextureRect = get_node("VContainer/ArmorBackgroundTexture")
onready var equipment_item: TextureRect = equipment_background.get_node("Item")

var equipment_dictionary: Dictionary = {}
var equipment_name: String = ""
var equipment_type: String = ""
var equipment_price: int

onready var consumable_background: TextureRect = get_node("ConsumableBackgroundTexture")
onready var consumable_item: TextureRect = consumable_background.get_node("Item")
onready var consumable_amount: Label = consumable_background.get_node("Amount")

var consumable_item_name: String = ""
var consumable_item_type: String = ""
var consumable_item_price: int
var consumable_item_amount: int
var consumable_item_type_value: int

var can_click: bool = false

func update_consumable_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if item_info[1] == consumable_item_name:
		consumable_item_amount += item_info[0]
		
		if consumable_item_amount > 9:
			var leftover: int = consumable_item_amount - 9
			item_info[0] = leftover
			consumable_item_amount = 9
			get_tree().call_group(
				"inventory", 
				"update_slot",
				consumable_item_name,
				consumable_item.texture,
				[
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
				consumable_item_type,
				consumable_item_type_value,
				consumable_item_price,
				consumable_item_amount
			]
		)
		
	consumable_item_name = item_info[1]
	consumable_item_type = item_info[2]
	consumable_item_price = item_info[4]
	consumable_item_amount = item_info[0]
	consumable_item_type_value = item_info[3]
	
	consumable_amount.text = str(consumable_item_amount)
	consumable_item.texture = item_texture
	consumable_amount.show()
	
	
func update_equipment_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if equipment_name != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			equipment_name,
			equipment_item.texture,
			[
				equipment_type,
				equipment_dictionary,
				equipment_price,
				1
			]
		)
		
		reset_equipment()
		
	equipment_item.texture = item_texture
	equipment_name = item_info[0]
	equipment_type = item_info[1]
	equipment_dictionary = item_info[2]
	equipment_price = item_info[3]
	
	equipment_item.show()
	
	get_tree().call_group("stats_hud", "update_bonus_stats", equipment_dictionary, false)
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		if consumable_item_amount > 0:
			match consumable_item_type:
				"Health":
					get_tree().call_group("player_stats", "update_health", "Increase", consumable_item_type_value)
					get_tree().call_group("player", "spawn_effect", "res://scenes/env/potion_effect.tscn")
					
				"Mana":
					get_tree().call_group("player_stats", "update_mana", "Increase", consumable_item_type_value)
					get_tree().call_group("player", "spawn_effect", "res://scenes/env/potion_effect.tscn")
					
			consumable_item_amount -= 1
			if consumable_item_amount == 0:
				reset()
				
			consumable_amount.text = str(consumable_item_amount)
			
			return
			
		reset()
		
		
func on_mouse_entered() -> void:
	can_click = true
	consumable_background.modulate.a = .5
	
	
func on_mouse_exited() -> void:
	can_click = false
	consumable_background.modulate.a = 1.0
	
	
func reset() -> void:
	consumable_item_name = ""
	consumable_item_type = ""
	consumable_item_price = 0
	consumable_item_type_value = 0
	consumable_amount.hide()
	consumable_item.texture = null
	
	
func reset_equipment() -> void:
	equipment_name = ""
	equipment_type = ""
	equipment_price = 0
	
	equipment_item.texture = null
	get_tree().call_group("stats_hud", "update_bonus_stats", equipment_dictionary, true)
	
	equipment_dictionary = {}
