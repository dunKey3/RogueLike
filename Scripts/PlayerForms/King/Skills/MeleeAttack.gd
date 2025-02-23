extends CharacterBody2D

@export var damage:float = 30.0

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		area.get_parent().take_damage(damage)
