extends Control
class_name ShoppingContainer

signal closed

onready var animation: AnimationPlayer = get_node("Animation")
onready var gold_animation: AnimationPlayer = get_node("Background/GoldAmount/Animation")

onready var grid_container: GridContainer = get_node("Background/ItemContainer")

onready var gold_amount: Label = get_node("Background/GoldAmount/GoldAmount")

onready var container: Array = [
	get_node("Background/CloseButton"),
	get_node("Background/GoldAmount/Icon")
]

var shop_list: Dictionary 

export(PackedScene) var item_container

func _ready() -> void:
	for item in container:
		item.connect("mouse_exited", self, "mouse_interaction", ["exited", item])
		item.connect("mouse_entered", self, "mouse_interaction", ["entered", item])
		
		if item is TextureButton:
			item.connect("pressed", self, "on_button_pressed", [item])
			
			
	for key in shop_list.keys():
		spawn_item(key)
		
		
func spawn_item(key: String) -> void:
	var item: ItemContainer = item_container.instance()
	item.update_container(key, shop_list[key])
	grid_container.add_child(item)
	
	
func mouse_interaction(state: String, item) -> void:
	match state:
		"entered":
			item.modulate.a = .5
			if item is TextureRect:
				gold_animation.play("show_gold")
			
		"exited": 
			item.modulate.a = 1.0
			if item is TextureRect:
				gold_animation.play("hide_gold")
				
				
func on_button_pressed(button: TextureButton) -> void:
	match button.name:
		"CloseButton":
			animation.play("hide_container")
			yield(animation, "animation_finished")
			emit_signal("closed")
			queue_free()
			
			
func _process(_delta: float) -> void:
	gold_amount.text = str(DataManagement.data_dictionary["player_gold"])
