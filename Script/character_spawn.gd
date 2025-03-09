class_name CharacterSpawner
extends Marker2D

@export var blocks : Array[Blocks]

const CHARACTER = preload("res://Scenes/character.tscn")

@onready var character_spawn_timer: Timer = $CharacterSpawnTimer




func spawn_characters(amount : int) -> void :
	if not Globals.blocos_ativos:
		return
	for i in amount:
		var char = CHARACTER.instantiate()
		
		add_child(char)
		char.create_character_with_block(Globals.blocos_ativos.pick_random().characteristics)

func _on_button_button_up() -> void:
	spawn_characters(10)


func _on_character_spawn_timer_timeout() -> void:
	if Globals.is_playing:
		spawn_characters(randi_range(1,6))
		character_spawn_timer.start(randf_range(3,10))
