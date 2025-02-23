extends Node2D

var index = 30

func _ready() -> void:
	for i in range(15):
		var arrow = load("res://Scenes/PlayerForms/Archer/Combat/Arrow.tscn")
		var curr = arrow.instantiate()
		curr.global_position = Vector2(30, index * i)
		curr.damage = 50
		add_child(curr)
