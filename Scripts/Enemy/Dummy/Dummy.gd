extends Node

@export var health = 999

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage):
	var dmg_indicator = RichTextLabel.new()
	
	dmg_indicator.push_color(Color(255,0,0))
	dmg_indicator.add_text(str(damage))
	dmg_indicator.set_size(Vector2(30,30))
	dmg_indicator.set_position(Vector2(-10,-62))
	
	add_child(dmg_indicator)
	dmg_indicator.global_position = $".".position
	health -= damage
	
	var target_position = Vector2(-10, -80)
	if dmg_indicator:
		var tween = get_tree().create_tween()
		tween.tween_property(dmg_indicator, "position", target_position, 0.5)
	
	await get_tree().create_timer(1.0).timeout
	dmg_indicator.queue_free()
