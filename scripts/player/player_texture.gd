extends Sprite

signal game_over

var magic_attack: bool = false
var normal_attack: bool = false

var shield_off: bool = true
var crouching_off: bool = true

var sufix: String = "_right"

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var player_ref = get_node(player_ref) as KinematicBody2D
export(NodePath) onready var attack_area_collision = get_node(attack_area_collision) as CollisionShape2D

func _ready() -> void:
	define_initial_texture()
	
	
func define_initial_texture() -> void:
	var file = File.new()
	if file.file_exists("user://save.dat"):
		DataManagement.load_data()
		texture = load(DataManagement.data_dictionary["player_texture"])
		print("Skin carregada: " + DataManagement.data_dictionary["player_texture"])
		
		
func animate(velocity: Vector2) -> void:
	verify_position(velocity)
	
	if player_ref.on_hit or player_ref.dead:
		hit_behavior()
	elif (player_ref.attacking or player_ref.defending or player_ref.crouching or player_ref.next_to_wall()) != false:
		action_behavior()
	elif velocity.y != 0:
		vertical_behavior(velocity)
	elif player_ref.landing:
		animation.play("landing")
		player_ref.set_physics_process(false)
	else:
		horizontal_behavior(velocity)
		
		
func hit_behavior() -> void:
	attack_area_collision.set_deferred("disabled", true)
	player_ref.set_physics_process(false)
	if player_ref.dead:
		animation.play("dead")
	elif player_ref.on_hit:
		animation.play("hit")
		
		
func action_behavior() -> void:
	if player_ref.next_to_wall():
		animation.play("wall_slide")
	elif player_ref.attacking and normal_attack:
		animation.play("attack" + sufix)
	elif player_ref.attacking and magic_attack:
		animation.play("spell_attack")
	elif player_ref.defending and shield_off:
		shield_off = false
		animation.play("shield")
	elif player_ref.crouching and crouching_off:
		crouching_off = false
		animation.play("crouch")
		
		
func vertical_behavior(velocity: Vector2) -> void:
	if velocity.y > 0:
		animation.play("fall")
	elif velocity.y < 0:
		animation.play("jump")
		
		
func horizontal_behavior(velocity: Vector2) -> void:
	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
		
		
func verify_position(velocity: Vector2) -> void:
	if velocity.x > 0:
		flip_h = false
		sufix = "_right"
		position = Vector2.ZERO
		player_ref.direction = -1
		player_ref.spell_offset = Vector2(100, -50)
		player_ref.wall_ray.cast_to = Vector2(5.5, 0)
		player_ref.collision_area.position = Vector2(1, 0)
	elif velocity.x < 0:
		flip_h = true
		sufix = "_left"
		position = Vector2(-2, 0)
		player_ref.direction = 1
		player_ref.spell_offset = Vector2(-100, -50)
		player_ref.wall_ray.cast_to = Vector2(-7.5, 0)
		player_ref.collision_area.position = Vector2(3, 0)
		
		
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"landing":
			player_ref.landing = false
			player_ref.set_physics_process(true)
			
		"attack_left":
			normal_attack = false
			player_ref.attacking = false
			
		"attack_right":
			normal_attack = false
			player_ref.attacking = false
			
		"spell_attack":
			magic_attack = false
			player_ref.attacking = false
			
		"hit":
			player_ref.on_hit = false
			player_ref.set_physics_process(true)
			
			if player_ref.defending:
				animation.play("shield")
				
			if player_ref.crouching:
				animation.play("crouch")
				
		"dead":
			emit_signal("game_over")
