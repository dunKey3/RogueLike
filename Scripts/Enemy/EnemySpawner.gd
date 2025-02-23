extends Node2D

@export var enemy_scene: PackedScene  # Reference to the Enemy scene

func spawn_enemy() -> void:
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.player = $"../../Player"
		enemy.global_position = position
		get_parent().add_child(enemy)  # Add the enemy
		
