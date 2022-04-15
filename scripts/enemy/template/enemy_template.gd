extends KinematicBody2D
class_name EnemyTemplate

signal kill

const FLOATING_TEXT: PackedScene = preload("res://scenes/env/floating_text.tscn")

onready var texture: Sprite = get_node("Texture")
onready var floor_ray: RayCast2D = get_node("FloorRay")
onready var animation: AnimationPlayer = get_node("Animation")

var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false

var velocity: Vector2
var drop_list: Dictionary
var player_ref: Player = null

export(int) var damage

export(int) var speed
export(int) var enemy_exp
export(int) var gravity_speed
export(int) var proximity_threshold
export(int) var raycast_default_position

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behavior()
	verify_position()
	texture.animate(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func move_behavior() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * speed 
			
		return
		
	velocity.x = 0
	
	
func gravity(delta: float) -> void:
	velocity.y += delta * gravity_speed
	
	
func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
		
	return false
	
	
func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		
		if direction > 0:
			texture.flip_h = true
			floor_ray.position.x = abs(raycast_default_position)
		elif direction < 0:
			texture.flip_h = false
			floor_ray.position.x = raycast_default_position
			
			
func kill_enemy() -> void:
	animation.play("kill")
	if player_ref != null:
		player_ref.stats.update_exp(enemy_exp)
		spawn_item_probability()
		
	emit_signal("kill")
	
	
func spawn_item_probability() -> void:
	for key in drop_list.keys():
		var random_number: int = randi() % 100 + 1
		if random_number <= drop_list[key][1]:
			var item_texture: StreamTexture = load(drop_list[key][0])
			var item_info: Array = [drop_list[key][2], drop_list[key][3], drop_list[key][4], 1]
			get_tree().call_group("inventory", "update_slot", key, item_texture, item_info)
			
			
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatText = FLOATING_TEXT.instance()
	text.rect_global_position = global_position
	
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	get_tree().root.call_deferred("add_child", text)
