extends EnemyTemplate
class_name Whale

func _ready() -> void:
	randomize()
	drop_list = {
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png", #Image Path Type
			20,                                               #Drop Probability
			"Health",                                         #Type
			5,                                                #Value
			3                                                 #Sell Price
		], 
		
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png", 
			5, 
			"Mana", 
			5, 
			10
		],
		
		"Whale Mouth": [
			"res://assets/item/resource/whale/whale_mouth.png",
			45,
			"Resource",
			{},
			2
		],
		
		"Whale Eye": [
			"res://assets/item/resource/whale/whale_eye.png",
			15,
			"Resource",
			{},
			8
		],
		
		"Whale Tail": [
			"res://assets/item/resource/whale/whale_tail.png",
			3,
			"Resource",
			{},
			25
		],
		
		"Whale Mask": [
			"res://assets/item/equipment/whale_mask.png",
			3,
			"Equipment",
			{
				"Mana": 5,
				"Magic Attack": 3
			},
			55
		]
	}
