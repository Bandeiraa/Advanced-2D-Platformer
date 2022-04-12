extends HBoxContainer
class_name ItemContainer

onready var item_texture: TextureRect = get_node("ItemTexture")

onready var item_info: Array

onready var item_name: Label = get_node("VContainer/ItemName")
onready var item_price: Label = get_node("VContainer/ItemPrice")

var can_click: bool = false
var price: int

func _ready() -> void:
	var _exited: bool = connect("mouse_exited", self, "mouse_interaction", ["exited"])
	var _entered: bool = connect("mouse_entered", self, "mouse_interaction", ["entered"])
	
	
func update_container(container_name: String, container_info: Array) -> void:
	yield(self, "ready")
	item_name.text = container_name
	item_texture.texture = load(container_info[0])
	item_price.text = str(container_info[1]) + " Gold Coins"
	price = container_info[1]
	item_info = [container_info[2], container_info[3], container_info[4], 1]
	
	
func mouse_interaction(state: String) -> void:
	match state:
		"entered":
			can_click = true
			modulate.a = .5
			
		"exited":
			can_click = false
			modulate.a = 1.0
			
			
func _process(_delta: float) -> void:
	var can_click_condition: bool = Input.is_action_just_pressed("click") and can_click
	if can_click_condition and (GlobalInfo.player_gold >= price):
		GlobalInfo.player_gold -= price
		get_tree().call_group("inventory", "update_slot", item_name.text, item_texture.texture, item_info)
		
		modulate.a = 0.2
		yield(get_tree().create_timer(0.1), "timeout")
		modulate.a = 0.5
