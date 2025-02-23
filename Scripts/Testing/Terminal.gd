extends GridContainer

var all_forms: Dictionary = {
	"res://Assests/Forms/Archer/archer.png" : "res://Scenes/PlayerForms/Archer/Archer.tscn",
	"res://Assests/Forms/King/king.png" : "res://Scenes/PlayerForms/King/King.tscn",
	"res://Assests/Forms/Goblin/goblin.png" : "res://Scenes/PlayerForms/Goblin.tscn"
}

signal sprite_clicked(texture_path, scene_path)  # Custom signal

var player

func _ready() -> void:
	player = get_parent().get_parent().find_child("Player")
	columns = 3  # Set the number of columns
	for texture_path in all_forms:
		var scene_path = all_forms[texture_path]
		var button = Button.new()  # Use Button for clickable sprites
		var texture = load(texture_path)

		# Extract the first frame from the spritesheet
		var image = texture.get_image()  # Get the image from the texture
		var frame_width = image.get_width() / 17  # Calculate frame width (hframes = 17)
		var frame_height = image.get_height()  # Calculate frame height (vframes = 1)

		# Crop the first frame
		var frame_image = image.get_region(Rect2(0, 0, frame_width, frame_height))
		var frame_texture = ImageTexture.create_from_image(frame_image)  # Create a new texture

		# Set the frame texture as the button's icon
		button.icon = frame_texture
		button.expand_icon = true
		button.custom_minimum_size = Vector2(32, 32)  # Set a smaller size
		button.connect("pressed", _on_sprite_clicked.bind(scene_path))  # Connect signal
		add_child(button)

func _on_sprite_clicked(scene_path: String) -> void:
	if player:
		player.load_form(scene_path)
	else:
		print("player not found")
