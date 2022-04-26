extends Control
class_name Dice

signal finished

onready var dice: TextureRect = get_node("Dice")
onready var texture_timer: Timer = get_node("TextureTimer")
onready var animation: AnimationPlayer = get_node("Animation")

var can_start_timer: bool = true
var current_dice_value: int

var dice_path_list: Array = [
	"res://assets/dice/00.png",
	"res://assets/dice/01.png",
	"res://assets/dice/02.png",
	"res://assets/dice/03.png",
	"res://assets/dice/04.png",
	"res://assets/dice/05.png",
	"res://assets/dice/06.png",
	"res://assets/dice/07.png",
	"res://assets/dice/08.png",
	"res://assets/dice/09.png",
	"res://assets/dice/10.png",
	"res://assets/dice/11.png",
	"res://assets/dice/12.png",
	"res://assets/dice/13.png",
	"res://assets/dice/14.png",
	"res://assets/dice/15.png",
	"res://assets/dice/16.png",
	"res://assets/dice/17.png",
	"res://assets/dice/18.png",
	"res://assets/dice/19.png",
	"res://assets/dice/20.png"
]

func _ready() -> void:
	randomize()
	
	
func select_random_number() -> int:
	return randi() % dice_path_list.size()
	
	
func on_current_dice_timeout():
	current_dice_value = select_random_number()
	dice.texture = load(dice_path_list[current_dice_value])
	if can_start_timer:
		texture_timer.start(0.1)
		
		
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"show_dice":
			texture_timer.stop()
			can_start_timer = false
			animation.play("hide_dice")
			emit_signal("finished", current_dice_value)
			
		"hide_dice":
			queue_free()
