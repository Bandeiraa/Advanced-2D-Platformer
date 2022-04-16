extends RigidBody2D
class_name PhysicItem

const COLLECT_EFFECT: PackedScene = preload("res://scenes/effect/collect_item.tscn")

onready var sprite: Sprite = get_node("ItemTexture")

var player_ref: KinematicBody2D = null

var item_name: String
var item_info_list: Array
var item_texture: StreamTexture

func _ready() -> void:
	apply_random_impulse()
	
	
func apply_random_impulse() -> void:
	randomize()
	apply_impulse(
		Vector2.ZERO, 
		Vector2(
			rand_range(-30, 30)
			,-90
		)
	)
	
	
func update_item_info(key: String, texture: StreamTexture, item_info: Array) -> void:
	yield(self, "ready") 
	
	item_name = key
	item_texture = texture
	item_info_list = item_info
	
	sprite.texture = texture
	
	
func on_screen_exited() -> void:
	queue_free()
	
	
func on_body_entered(body: Player) -> void:
	player_ref = body
	
	
func on_body_exited(_body: Player) -> void:
	player_ref = null
	
	
func _process(_delta: float) -> void:
	if player_ref != null and Input.is_action_just_pressed("interact"):
		get_tree().call_group("inventory", "update_slot", item_name, item_texture, item_info_list)
		spawn_effect()
		queue_free()
		
		
func spawn_effect() -> void:
	var effect: EffectTemplate = COLLECT_EFFECT.instance()
	effect.global_position = global_position
	get_tree().root.call_deferred("add_child", effect)
	effect.play_effect()
