extends Sprite

#signal aux_camera
signal game_over

var shield_off: bool = true
var crouching_off: bool = true

var skins_list: Array = [
	"res://assets/player/char_blue.png", #default
	"res://assets/player/char_green.png",
	"res://assets/player/char_purple.png",
	"res://assets/player/char_red.png"
]

var sufix: String = "_right"

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var player_ref = get_node(player_ref) as KinematicBody2D

func _ready() -> void:
	randomize()
	define_initial_texture()
	
	
func define_initial_texture() -> void:
	var file = File.new()
	if file.file_exists("user://save.dat"):
		DataManagement.load_data()
		texture = load(DataManagement.data_dictionary["player_texture"])
		print("Skin carregada: " + DataManagement.data_dictionary["player_texture"])
		return
		
	var random_int: int = randi() % skins_list.size()
	texture = load(skins_list[random_int])
	DataManagement.data_dictionary["player_texture"] = skins_list[random_int]
	DataManagement.save_data()
	
	
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
	player_ref.set_physics_process(false)
	if player_ref.dead:
		animation.play("dead")
	elif player_ref.on_hit:
		animation.play("hit")
		
		
func action_behavior() -> void:
	if player_ref.next_to_wall():
		animation.play("wall_slide")
	elif player_ref.attacking:
		animation.play("attack" + sufix)
		#player_ref.set_physics_process(false)
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
		player_ref.wall_ray.cast_to = Vector2(5.5, 0)
		player_ref.collision_area.position = Vector2(1, 0)
	elif velocity.x < 0:
		flip_h = true
		sufix = "_left"
		position = Vector2(-2, 0)
		player_ref.direction = 1
		player_ref.wall_ray.cast_to = Vector2(-7.5, 0)
		player_ref.collision_area.position = Vector2(3, 0)
		
		
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"landing":
			player_ref.landing = false
			player_ref.set_physics_process(true)
			
		"attack_left":
			player_ref.attacking = false
			#player_ref.set_physics_process(true)
			
		"attack_right":
			player_ref.attacking = false
			#player_ref.set_physics_process(true)
			
		"hit":
			player_ref.on_hit = false
			player_ref.set_physics_process(true)
			
			if player_ref.defending:
				animation.play("shield")
				
			if player_ref.crouching:
				animation.play("crouch")
				
		"dead":
			emit_signal("game_over")
			#emit_signal("aux_camera", player_ref.get_node("LevelCamera").global_position)
			#player_ref.queue_free()
