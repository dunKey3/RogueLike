extends CanvasLayer

@onready var timer_label = $Timer/Label
@onready var time_elapsed: float = 0.0

@onready var Portrait = $Portrait

@onready var health = $"Health and skills/Health"

@onready var skill1 = $"Health and skills/Skill1"
@onready var skill2 = $"Health and skills/Skill2"

@export var max_health = 1000.0

func _ready():
	health.max_value = max_health
	health.min_value = 0
	health.value = max_health
	
	set_skill1_cooldown(false)
	set_skill2_cooldown(false)

func _process(delta: float) -> void:
	time_elapsed += delta
	timer_label.text = str(time_elapsed).pad_decimals(2)

func _set_portrait(texture_path: String):
	var tex = load(texture_path)
	Portrait.set_texture(tex)

func set_skill1_cooldown(on_cooldown: bool):
	if on_cooldown:
		skill1.set_self_modulate(Color(1,1,1,0.4))
	else:
		skill1.set_self_modulate(Color(1,1,1,1))
	
func set_skill2_cooldown(on_cooldown: bool):
	if on_cooldown:
		skill2.set_self_modulate(Color(1,1,1,0.4))
	else:
		skill1.set_self_modulate(Color(1,1,1,1))

func _update_health(curr_health : float):
	health.value = curr_health
