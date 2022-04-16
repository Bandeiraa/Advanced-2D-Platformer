extends EnemyTemplate
class_name Crabby

var attack_animation_suffix: String = "_left"

func _ready() -> void:
	randomize()
	drop_list = {
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png", #Image Path Type
			15,                                               #Drop Probability
			"Health",                                         #Type
			5,                                                #Value
			3                                                 #Sell Price
		], 
		
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png", 
			8, 
			"Mana", 
			5, 
			10
		],
		
		"Crabby Eye": [
			"res://assets/item/resource/crabby/crab_eye.png",
			35,
			"Resource",
			{},
			2
		],
		
		"Crabby Pincers": [
			"res://assets/item/resource/crabby/crab_pincers.png",
			10,
			"Resource",
			{},
			10
		],
		
		"Crabby Belt": [
			"res://assets/item/equipment/crabby_belt.png",
			5, 
			"Equipment",
			{
				"Health": 3,
				"Attack": 1
			},
			35
		],
		
		"Crabby Axe": [
			"res://assets/item/equipment/crabby_axe.png",
			2, 
			"Weapon",
			{
				"Attack": 3,
				"Defense": 1
			},
			85
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
