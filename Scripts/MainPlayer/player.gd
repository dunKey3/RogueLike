extends Node2D

@onready var HUD = $"../Hud"

@export var form_scenes: Dictionary = {
	"form1": "res://Scenes/PlayerForms/King/King.tscn",
	"form2": "res://Scenes/PlayerForms/Archer/Archer.tscn"
}

@export var form_portraits: Dictionary = {
	"form1": "res://Assests/Portraits/King.png",
	"form2": "res://Assests/Portraits/Archer.png"
}

var Health = 1000.0

var current_form: CharacterBody2D
var current_form_key: String

var form_cooldown : bool = false
var form_cooldown_timer: float = 4.0

@onready var forms_container: Node2D = $"."

func take_damage(damage: float):
	Health -= damage
	HUD._update_health(Health)
	
	current_form.find_child("Area2D").set_deferred("monitorable", false)
	await get_tree().create_timer(1.0).timeout
	current_form.find_child("Area2D").set_deferred("monitorable", true)
	

func _ready():
	load_form("form1")
	form_cooldown = false  # Load the initial form
	HUD.max_health = Health
	HUD._set_portrait(form_portraits[current_form_key])

func _physics_process(delta: float) -> void:
	# Pass control to the current form
	if current_form and current_form.has_method("_physics_process"):
		current_form._physics_process(delta)
	handle_input(delta)
	if form_cooldown == true:
		form_cooldown_timer -= delta
		if form_cooldown_timer <= 0.0:
			form_cooldown = false
			form_cooldown_timer = 10.0

func handle_input(delta: float) -> void:
	if Input.is_action_pressed("form1"):
		load_form("form1")
	if Input.is_action_pressed("form2"):
		load_form("form2")
	if Input.is_action_pressed("form3"):
		load_form("form3")
	

func load_form(form_key: String) -> void:
	if form_cooldown:
		return

	if not form_scenes.has(form_key):
		print("Form '%s' not found in form_scenes!" % form_key)
		return
	
	PhysicsServer2D.set_active(false)
	# Save the current form's position
	var saved_direction = 1
	var saved_position = position
	if current_form:
		saved_direction = current_form.find_child("Sprite2D").scale.x
		saved_position = current_form.global_position
		current_form.queue_free()

	# Load and instance the new form
	var form_scene = load(form_scenes[form_key]) as PackedScene
	current_form = form_scene.instantiate()
	
	# Set the position of the new form
	forms_container.add_child(current_form)
	current_form.global_position = saved_position
	
	current_form.collision_layer = 1
	current_form.collision_mask = 2
	
	PhysicsServer2D.set_active(true)

	current_form_key = form_key
	HUD._set_portrait(form_portraits[current_form_key])
	form_cooldown = true
