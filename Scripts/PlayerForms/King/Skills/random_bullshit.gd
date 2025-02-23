extends Node2D

@export var throw_direction = 1

var skill_sprites: Array = [
	"res://Assests/Forms/King/Throwables/1.png",
	"res://Assests/Forms/King/Throwables/2.png",
	"res://Assests/Forms/King/Throwables/3.png",
	"res://Assests/Forms/King/Throwables/4.png",
	"res://Assests/Forms/King/Throwables/5.png",
	"res://Assests/Forms/King/Throwables/6.png",
	"res://Assests/Forms/King/Throwables/7.png",
	"res://Assests/Forms/King/Throwables/8.png",
	"res://Assests/Forms/King/Throwables/9.png",
	"res://Assests/Forms/King/Throwables/10.png",
]

var damage = 5
var chosen_sprites: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		chosen_sprites.append(skill_sprites[randi_range(0,9)])
	_set_sprites()

func _set_sprites() -> void:
	var sprite_children = get_children()
	for i in range(5):
		sprite_children[i].find_child("Sprite2D").texture = load(chosen_sprites[i])
		sprite_children[i].set_linear_velocity(Vector2(randi_range(400,600) * throw_direction,randi_range(-300, -400)))
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		area.get_parent().take_damage(damage)
		area.get_parent().queue_free()
