extends CharacterBody2D

@export var speed: float = 250.0
@export var decel: float = 0.5
@export var accel: float = 0.5

@export var dash_speed:float = 400.0
@export var dash_max_distance:float = 100.0
@export var dash_curve : Curve
@export var dash_cooldown:float = 1.0
 
var is_dashing = false
var dash_start_position:float = 0.0
var dash_direction:float = 0.0
var dash_timer:float = 0.0

@export var gravity: float = 900.0  

@export var jump_force: float = 450.0
@export var jump_decel:float = 0.5

var is_on_ground: bool = false
var is_walking: bool = false


var attack_on_cooldown = false
var attack_cooldown = 0.4

func _physics_process(delta: float) -> void:
	handle_input(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.x == 0 or not is_on_ground:
		is_walking = false
	else:
		is_walking = true
	
	
	move_and_slide()
	is_on_ground = is_on_floor()
	if is_walking and is_on_ground:
		$Sprite2D/AnimationPlayer.play("walk")
	if not is_walking and is_on_ground:
		$Sprite2D/AnimationPlayer.play("Idle")
	
func handle_input(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		$Sprite2D.scale.x = 1;
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		$Sprite2D.scale.x = -1;
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, speed * accel)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * decel)

	if (is_on_wall or is_on_ground) and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
		$Sprite2D/AnimationPlayer.play("jump")
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_decel
	
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction.x
		dash_timer = dash_cooldown
 
	# Performs actual dash
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
		else:
			if velocity.x == 0:
				velocity.x = dash_speed * 4
			else:
				velocity.x = dash_direction * dash_speed
				velocity.y = 0
 
	# Reduces the dash timer
	if dash_timer > 0:
		dash_timer -= delta
	
	if Input.is_action_just_pressed("Melee Attack") and not attack_on_cooldown:
		_attack()
		
	if Input.is_action_just_pressed("skill1"):
		_skill1()
	
	if Input.is_action_just_pressed("skill2"):
		_skill2()
	
	if attack_on_cooldown:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			attack_on_cooldown = false
			attack_cooldown = 2.0

func _skill1() -> void:
	var skill_scene = load("res://Scenes/PlayerForms/King/Combat/King_RandomBullshitGo.tscn") as PackedScene
	var skill = skill_scene.instantiate()
	
	skill.position = global_position
	skill.throw_direction = $Sprite2D.scale.x
	get_tree().root.add_child(skill)
	
	await get_tree().create_timer(2).timeout
	skill.queue_free()
	

func _skill2() -> void:
	var skill_scene = load("res://Scenes/PlayerForms/King/Combat/King_Shield.tscn") as PackedScene
	var skill = skill_scene.instantiate()
	
	skill.position = Vector2.ZERO
	
	add_child(skill)
	
	await get_tree().create_timer(4).timeout
	skill.queue_free()

func _attack() -> void:
	if attack_on_cooldown:
		return
	
	# Load and instantiate the soldier
	var soldier_scene = load("res://Scenes/PlayerForms/King/Combat/King_MeleeAttack.tscn") as PackedScene
	var soldier = soldier_scene.instantiate()
	
	# Set position and add to the correct parent  # Use global position
	var spawn_offset = Vector2(10 * $Sprite2D.scale.x, 0)  # Adjust offset to where the soldier should originate
	soldier.global_position = global_position + spawn_offset
	soldier.find_child("Sprite2D").scale.x = $Sprite2D.scale.x
	
	get_tree().root.add_child(soldier) 
	
	var initial_velocity = 0
	var target_position = Vector2.ZERO
	if velocity.x > 0.0:
		initial_velocity = velocity.x/2
		target_position = $".".global_position + Vector2(initial_velocity * $Sprite2D.scale.x, 0)
	if velocity.x < -200:
		initial_velocity = velocity.x/2
		target_position = $".".global_position + Vector2(initial_velocity, 0)
	if velocity.x == 0.0:
		initial_velocity = 60
		target_position = $".".global_position + Vector2(initial_velocity * $Sprite2D.scale.x, 0)
	
	if soldier:
		var tween = get_tree().create_tween()
		tween.tween_property(soldier, "global_position", target_position, 0.1)
	
	attack_on_cooldown = true
	
	await get_tree().create_timer(0.5).timeout
	soldier.queue_free()
