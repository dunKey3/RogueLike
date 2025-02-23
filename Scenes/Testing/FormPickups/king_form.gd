extends Node2D

@export var form_location = "res://Scenes/PlayerForms/King/King.tscn"
var cooldown = 8.0
var on_cooldown = false

func _process(delta: float) -> void:
	if on_cooldown:
		cooldown -= delta
	if cooldown <= 0.0:
		on_cooldown = false
		cooldown = 8.0
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
			on_cooldown = true
			print("Interact pressed")
			var player = area.get_parent().get_parent()
			player.form_scenes[player.current_form_key] = form_location
			print(player.form_scenes[player.current_form_key])
			player.form_cooldown = false
			player.call_deferred("load_form",player.current_form_key)
	
