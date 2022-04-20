extends EnemyTemplate
class_name PinkStar

var attack_animation_suffix: String = "_left"

func _ready() -> void:
	randomize()
	drop_list = {
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png", #Image Path Type
			25,                                               #Drop Probability
			"Health",                                         #Type
			5,                                                #Value
			2                                                 #Sell Price
		], 
		
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png", 
			12, 
			"Mana", 
			5, 
			5
		],
		
		"Pink Star Mouth": [
			"res://assets/item/resource/pink_star/pink_star_mouth.png",
			47,
			"Resource",
			{},
			5
		],
		
		"Pink Star Bow": [
			"res://assets/item/equipment/pink_star_bow.png",
			1,
			"Weapon",
			{
				"Attack": 5
			},
			60
		],
		
		"Pink Star Belt": [
			"res://assets/item/equipment/pink_star_belt.png",
			3, 
			"Equipment",
			{
				"Health": 5,
				"Mana": 5
			},
			40
		],
		
		"Pink Star Shield": [
			"res://assets/item/equipment/pink_star_shield.png",
			1,
			"Weapon",
			{
				"Health": 3,
				"Defense": 2
			},
			75
		]
	}
	
	
func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		
		if direction > 0:
			texture.flip_h = true
			attack_animation_suffix = "_right"
			floor_ray.position.x = abs(raycast_default_position)
		elif direction < 0:
			texture.flip_h = false
			attack_animation_suffix = "_left"
			floor_ray.position.x = raycast_default_position
