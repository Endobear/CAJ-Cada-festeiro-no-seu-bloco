extends Marker2D

@export var blocks : Array[Blocks]

const CHARACTER = preload("res://Scenes/character.tscn")

func _ready() -> void:
	if !blocks:
		blocks = [Blocks.new()]
	


	
	
func spawn_characters(amount : int) -> void :
	for i in amount:
		var char = CHARACTER.instantiate()
		char.create_character_with_block(blocks.pick_random())
		add_child(char)

func _on_button_button_up() -> void:
	spawn_characters(1)
