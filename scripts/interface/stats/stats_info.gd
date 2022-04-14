extends TextureRect
class_name StatsInfo

onready var animation: AnimationPlayer = get_node("Animation")

onready var stat_texture: TextureRect = get_node("Stat")
onready var target_stat_texture: TextureRect = get_node("TargetStat")

var stat_image_list: Dictionary = {
	"attack": "res://assets/interface/stats/text/stats_text/small/attack.png",
	"defense": "res://assets/interface/stats/text/stats_text/small/defense.png",
	"health": "res://assets/interface/stats/text/stats_text/small/health.png",
	"magic attack": "res://assets/interface/stats/text/stats_text/small/magic_attack.png",
	"mana": "res://assets/interface/stats/text/stats_text/small/mana.png"
}

func update_container(stat: String) -> void:
	stat_texture.texture = load(stat_image_list[stat])
	target_stat_texture.texture = load(stat_image_list[stat])
	
	
func play_animation(anim_name: String) -> void:
	animation.play(anim_name)
