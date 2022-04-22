extends DestructableInteractable

var drop_list: Dictionary = {
	"Heal Potion": [
		"res://assets/item/consumable/health_potion.png", #Image Path Type
		35,                                               #Drop Probability
		"Health",                                         #Type
		5,                                                #Value
		2                                                 #Sell Price
	], 
	
	"Mana Potion": [
		"res://assets/item/consumable/mana_potion.png", 
		8, 
		"Mana", 
		5, 
		5
	],
}

var barrel_slice: Array = [
	"res://assets/interactable/barrel/destroyed_barrel_1.png",
	"res://assets/interactable/barrel/destroyed_barrel_2.png",
	"res://assets/interactable/barrel/destroyed_barrel_3.png",
	"res://assets/interactable/barrel/destroyed_barrel_4.png"
]

export(int) var dice_amount

func spawn() -> void:
	for slice_path in barrel_slice:
		var slice: Slice = SLICE.instance()
		slice.slice_texture_path = slice_path
		slice.global_position = global_position
		get_tree().root.call_deferred("add_child", slice)
		
	for dice in dice_amount:
		spawn_item_probability()
		
		
func spawn_item_probability() -> void:
	for key in drop_list.keys():
		var random_number: int = randi() % 100 + 1
		if random_number <= drop_list[key][1]:
			var item_texture: StreamTexture = load(drop_list[key][0])
			var item_info: Array = [drop_list[key][0], drop_list[key][2], drop_list[key][3], drop_list[key][4], 1]
			spawn_physic_item(key, item_texture, item_info)
			
			
func spawn_physic_item(key: String, item_texture: StreamTexture, item_info: Array) -> void:
	var item: PhysicItem = PHYSIC_ITEM.instance()
	get_tree().root.call_deferred("add_child", item)
	item.global_position = global_position
	item.update_item_info(key, item_texture, item_info)
	
	
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		animation.play("idle")
