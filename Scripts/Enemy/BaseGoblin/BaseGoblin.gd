extends CharacterBody2D

@export var speed: float = 60.0  # Speed of the enemy
var direction: Vector2 = Vector2(1,0)  # Initial direction of movement
var damage: float = 30.0
var gravity: float = 1800.0
var max_Health:float = 90
var Health: float = max_Health
var HealthBar: ProgressBar
var health_style
@export var player: Node2D

func _ready() -> void:
	HealthBar = $"ProgressBar"
	health_style = StyleBoxFlat.new()
	HealthBar.add_theme_stylebox_override("fill", health_style)
	health_style.set_bg_color("#00FF00")
	
	if not player:
		print("Player Not Found!")
	else:
		$NavigationAgent2D.target_position = player.global_position
	
func _physics_process(delta: float) -> void:
		

	if player:
		$NavigationAgent2D.target_position = player.get_children()[0].global_position
		var next_position = $NavigationAgent2D.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.y += gravity * delta
		move_and_slide()

func take_damage(player_damage: float):
	Health -= player_damage
	
	if(Health <= 0):
		queue_free()
	if(Health < max_Health):
		health_style.set_bg_color("#8B8000")
	if(Health < max_Health / 2):
		health_style.set_bg_color("#8B0000")
	HealthBar.set_value_no_signal(Health)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().get_parent().take_damage(damage)
