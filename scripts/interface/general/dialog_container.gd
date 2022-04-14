extends Control
class_name DialogContainer

signal finished

onready var timer: Timer = get_node("Timer")
onready var animation: AnimationPlayer = get_node("Animation")
onready var dialog_text: RichTextLabel = get_node("ContainerBackground/Text")

onready var dialog_name: Label = get_node("ContainerBackground/Name")
onready var dialog_portrait: TextureRect = get_node("ContainerBackground/Portrait")

onready var buttons_container: HBoxContainer = get_node("ContainerBackground/ButtonsContainer")

var dialog_size: int
var dialog_index: int = 0

var can_change_dialog: bool

var dialog_list: Dictionary

export(float) var timer_cooldown

func _ready() -> void:
	for button in buttons_container.get_children():
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", ["exited", button])
		button.connect("mouse_entered", self, "mouse_interaction", ["entered", button])
		
	dialog_size = dialog_list["dialog"].size()
	if dialog_list["portrait"] != null:
		dialog_name.text = dialog_list["name"]
		dialog_text.rect_position = Vector2(47, 24)
		dialog_portrait.texture = load(dialog_list["portrait"])
		
	show_dialog()
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_change_dialog:
		show_dialog()
		can_change_dialog = false
		
		
func show_dialog() -> void:
	if dialog_index == dialog_size:
		animation.play("hide_container")
		yield(animation, "animation_finished")
		emit_signal("finished")
		queue_free()
		return
		
	dialog_text.percent_visible = 0
	dialog_text.text = dialog_list["dialog"][dialog_index]
	dialog_index += 1
	
	while dialog_text.visible_characters < len(dialog_text.text):
		dialog_text.visible_characters += 1
		timer.start(timer_cooldown)
		yield(timer, "timeout")
		
	if dialog_index == dialog_size and dialog_list["choice"]:
		animation.play("show_buttons")
		buttons_container.get_node("LeftButton/Text").text = dialog_list["left_choice"]
		buttons_container.get_node("RightButton/Text").text = dialog_list["right_choice"]
	else:
		can_change_dialog = true
		
		
func mouse_interaction(state: String, button: TextureButton) -> void:
	match state:
		"entered":
			button.modulate.a = 0.5
			
		"exited":
			button.modulate.a = 1.0
			
			
func on_button_pressed(button: TextureButton) -> void:
	button.modulate.a = 0.2
	yield(get_tree().create_timer(0.1), "timeout")
	button.modulate.a = 0.5
	animation.play("hide_container")
	yield(animation, "animation_finished")
	emit_signal("finished", button.get_node("Text").text)
	queue_free()
