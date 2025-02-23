extends CharacterBody2D

@export var speed: float = 400.0
@export var dash_speed: float = 3.0
@export var gravity: float = 900.0  
@export var jump_force: float = 400.0
var is_on_ground: bool = false

var is_dashing: bool = false
var dash_timer: float = 0.3
var dash_elapsed: float = 0.0

func _physics_process(delta: float) -> void:
	handle_input(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	is_on_ground = is_on_floor()
	
func handle_input(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		$Sprite2D.scale.x = 1;
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		$Sprite2D.scale.x = -1;
	velocity.x = direction.x * speed

	if is_on_ground and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force

	# Dash mechanic
	if Input.is_action_just_pressed("dash") and not is_dashing:
		is_dashing = true
		dash_elapsed = dash_timer

	if is_dashing:
		velocity.x = dash_speed * velocity.x
		dash_elapsed -= delta
		if dash_elapsed <= 0.0:
			is_dashing = false

func return_global_position() -> Vector2:
	return $".".position
