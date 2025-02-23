extends CharacterBody2D

@export var speed: float = 800.0  # Speed of the arrow
@export var direction: Vector2 = Vector2.RIGHT  # Direction of the arrow
var gravity: float = 900.0  # Optional: Add gravity if you want arrows to fall
var damage:float

func _ready() -> void:
	$Sprite2D.scale.x *= direction.x

func _physics_process(delta: float) -> void:
	velocity = Vector2(direction.x * speed, 0)
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		area.get_parent().take_damage(floor(damage))
		gravity = 0
		await get_tree().create_timer(0.1).timeout
		queue_free()
	else:
		gravity = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
