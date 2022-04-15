extends InteractableTemplate
class_name Shopping

var dialog_list: Dictionary = {
	"name": "Merchant",
	"portrait": "res://assets/interface/dialog/merchant_portrait.png",
	"dialog": [
		"Hello, Adventurer... he he",
		"What do you want?",
	],
	"left_choice": "buy",
	"right_choice": "sell",
	"choice": true
}

var shop_list: Dictionary = {
	"Heal Potion": [
		"res://assets/item/consumable/health_potion.png", 
		5, 
		"Health", 
		5, 
		2
	],
	 
	"Mana Potion": [
		"res://assets/item/consumable/mana_potion.png", 
		15, 
		"Mana", 
		5, 
		5
	],
	
	"Crabby Belt": [
			"res://assets/item/equipment/crabby_belt.png",
			90,
			"Equipment",
			{
				"Health": 3,
				"Attack": 1
			},
			30
		],
		
	"Crabby Axe": [
			"res://assets/item/equipment/crabby_axe.png",
			120,
			"Weapon",
			{
				"Attack": 3,
				"Defense": 1
			},
			40
		],
		
	"Whale Mask": [
			"res://assets/item/equipment/whale_mask.png",
			90,
			"Equipment",
			{
				"Mana": 5,
				"Magic Attack": 3
			},
			30
		]
}

func interactable_action() -> void:
	get_tree().call_group("hud", "spawn_dialog", self, dialog_list)
	dialog_icon_animation.play("hide_container")
	player_ref.reset(false)
	
	
func on_dialog_finished(action: String) -> void:
	match action:
		"buy":
			get_tree().call_group("hud", "spawn_shop", self, shop_list)
			
		"sell":
			get_tree().call_group("hud", "spawn_sell_shop", self)
			
			
func on_shop_closed() -> void:
	can_interact = true
	player_ref.reset(true)
	dialog_icon_animation.play("show_container")
	get_tree().call_group("hud", "normal_state")
