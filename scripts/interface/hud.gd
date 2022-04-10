extends CanvasLayer

onready var inventory_container: Control = get_node("InventoryContainer")
onready var stats_container: Control = get_node("StatsContainer")
onready var bar_container: Control = get_node("BarContainer")

var can_show_container: bool = true

export(PackedScene) var dialog_container
export(PackedScene) var shopping_container
export(PackedScene) var sell_shopping_container

func spawn_dialog(interactable, dialog_dict: Dictionary) -> void:
	var dialog: DialogContainer = dialog_container.instance()
	var _finished: bool = dialog.connect("finished", interactable, "on_dialog_finished")
	dialog.dialog_list = dialog_dict
	hide_containers()
	add_child(dialog)
	
	
func spawn_shop(interactable, shop_dict: Dictionary) -> void:
	var shop: ShoppingContainer = shopping_container.instance()
	var _closed: bool = shop.connect("closed", interactable, "on_shop_closed")
	shop.shop_list = shop_dict
	add_child(shop)
	
	
func spawn_sell_shop(interactable) -> void:
	var sell_shop: SellContainer = sell_shopping_container.instance()
	var _closed: bool = sell_shop.connect("closed", interactable, "on_shop_closed")
	add_child(sell_shop)
	
	
func _process(_delta: float) -> void:
	show_inventory()
	show_stats()
	
	
func show_inventory() -> void:
	if Input.is_action_just_pressed("inventory") and can_show_container:
		inventory_container.is_visible = !inventory_container.is_visible
		if inventory_container.is_visible:
			inventory_container.animation.play("show_container")
		else:
			inventory_container.reset()
			inventory_container.animation.play("hide_container")
			
		if stats_container.is_visible:
			stats_container.reset()
			stats_container.is_visible = false
			stats_container.animation.play("hide_container")
			
			
func show_stats() -> void:
	if Input.is_action_just_pressed("stats") and can_show_container:
		stats_container.is_visible = !stats_container.is_visible
		if stats_container.is_visible:
			stats_container.animation.play("show_container")
		else:
			stats_container.reset()
			stats_container.animation.play("hide_container")
			
		if inventory_container.is_visible:
			inventory_container.reset()
			inventory_container.is_visible = false
			inventory_container.animation.play("hide_container")
			
			
func hide_containers() -> void:
	can_show_container = false
	for node in get_children():
		if node.visible and node.is_in_group("bar_container"):
			node.animation.play("hide_container")
		elif node.visible:
			node.animation.play("hide_container")
			node.reset()
			
			
func normal_state() -> void:
	can_show_container = true
	bar_container.animation.play("show_container")
