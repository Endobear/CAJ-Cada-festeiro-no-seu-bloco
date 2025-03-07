class_name CharacterSpawner
extends Marker2D

@export var blocks : Array[Blocks]

const CHARACTER = preload("res://Scenes/character.tscn")

	
	
func spawn_characters(amount : int) -> void :
	if not blocks:
		return
	for i in amount:
		var char = CHARACTER.instantiate()
		
		add_child(char)
		char.create_character_with_block(blocks.pick_random())

func _on_button_button_up() -> void:
	spawn_characters(1)
