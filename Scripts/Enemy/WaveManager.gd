extends Node2D
#
#var current_wave
#var wave_timer: float = 4.0
#
#func _ready() -> void:
	#current_wave = 1
#
#func _physics_process(delta: float) -> void:
	#wave_timer -= delta
	#if wave_timer <= 0.0:
		#spawn_wave()
		#wave_timer = 4.0
#
#func spawn_wave():
	#var children = get_children()
	#for i in children:
		#if i is not CharacterBody2D:
			#i.spawn_enemy()
