extends CharacterBody2D

@export var speed: float = 300.0
@export var dash_speed: float = 3.0
@export var gravity: float = 900.0  
@export var jump_force: float = 400.0
var is_on_ground: bool = false

var is_dashing: bool = false
var dash_timer: float = 0.2
var dash_elapsed: float = 0.0

var arrow_charge = 0.0

var attack_cooldown = 1.0
var attack_on_cooldown = false

func _ready() -> void:
	var swap_attack = load("res://Scenes/PlayerForms/Archer/Combat/ArrowRain.tscn")
	var swap_scene = swap_attack.instantiate()
	get_tree().root.add_child.call_deferred(swap_scene)

func _physics_process(delta: float) -> void:
	handle_input(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	is_on_ground = is_on_floor()

func _attack() -> void:
	if attack_on_cooldown:
		return

	var arrow_scene = load("res://Scenes/PlayerForms/Archer/Combat/Arrow.tscn") as PackedScene
	var arrow = arrow_scene.instantiate()
	
	arrow.speed = arrow_charge * 300 + 100
	arrow.damage = arrow_charge * 20
	arrow.direction.x *= $Sprite2D.scale.x
	arrow.global_position = global_position + Vector2(10 * $Sprite2D.scale.x,0)
	get_tree().root.add_child(arrow)
	
	attack_on_cooldown = true

func _skill1() -> void:
	# Backdash based on the player's facing direction
	var backdash_force = 2400.0  # Adjust this value to control the backdash strength
	if $Sprite2D.scale.x == 1:  # Facing right
		velocity.x = -backdash_force
	else:  # Facing left
		velocity.x = backdash_force

func handle_input(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		$Sprite2D.scale.x = 1;
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		$Sprite2D.scale.x = -1;
	velocity.x = direction.x * speed
	
	if Input.is_action_just_pressed("skill1"):
		_skill1()
	
	if Input.is_action_pressed("Melee Attack"):
		if arrow_charge <= 2.0:
			arrow_charge += delta
	
	if Input.is_action_just_released("Melee Attack"):
		_attack()
		arrow_charge = 0.0
	
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
			
	if attack_on_cooldown:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			attack_on_cooldown = false
			attack_cooldown = 2.0

func return_global_position() -> Vector2:
	return $".".position
