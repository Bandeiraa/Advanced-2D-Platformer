extends KinematicBody2D
class_name Player

onready var stats: Stats = get_node("Stats")
onready var wall_ray: RayCast2D = get_node("WallRay")
onready var player_sprite: Sprite = get_node("Texture")
onready var collision_area: Area2D = get_node("CollisionArea")

onready var animation: AnimationPlayer = get_node("Animation")

var velocity: Vector2

var direction: int = 1
var jump_count: int = 0

var dead: bool = false
var on_hit: bool = false
var landing: bool = false
var on_wall: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var not_on_wall: bool = true
var can_track_input: bool = true

export(int) var speed
export(int) var jump_speed
export(int) var wall_jump_speed

export(int) var wall_gravity
export(int) var player_gravity
export(int) var wall_impulse_speed

export(NodePath) onready var stats_ref = get_node(stats_ref) as Node

func _physics_process(delta: float) -> void:
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	player_sprite.animate(velocity)
	
	
func actions_env() -> void:
	attack()
	crouch()
	defense()
	
	
func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		attacking = true
		
		
func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		defending = false
		can_track_input = false
		stats_ref.shielding = false
	elif not defending:
		crouching = false
		can_track_input = true
		stats_ref.shielding = false
		player_sprite.crouching_off = true
		
		
func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		crouching = false
		can_track_input = false
		stats_ref.shielding = true
	elif not crouching:
		defending = false
		can_track_input = true
		stats_ref.shielding = false
		player_sprite.shield_off = true
		
		
func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if not can_track_input or attacking:
		velocity.x = 0
		return
		
	velocity.x = input_direction * speed
	
	
func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall():
		jump_count = 0
		
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and can_track_input and not attacking:
		jump_count += 1
		
		if next_to_wall() and not is_on_floor():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
			landing = true
		else:
			velocity.y = jump_speed
			landing = true
			
			
func gravity(delta: float) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
			
	else:
		velocity.y += player_gravity * delta
		if velocity.y >= player_gravity:
			velocity.y = player_gravity
			
			
func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not_on_wall:
			velocity.y = 0
			not_on_wall = false
			
		return true
		
	else:
		not_on_wall = true
		return false
		
		
func reset(state: bool) -> void:
	set_physics_process(state)
	animation.play("idle")
	
	landing = false
	on_wall = false
	attacking = false
	defending = false
	crouching = false