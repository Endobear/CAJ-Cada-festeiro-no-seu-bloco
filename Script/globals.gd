extends Node

const STRIKE = preload("res://Scenes/UI/strike.tscn")
const LEVEL = preload("res://Scenes/level.tscn")

var dragging : Character

var blocos : Array[BlockArea]
var blocos_ativos : Array[BlockArea]

var points : int = 0

var strikes : int = 0

var spawner

signal game_over

var is_playing : bool = false


func populateBlocks(blocks : Array[Node]):
	blocos.clear()
	
	for block in blocks:
		if block is BlockArea:
			blocos.append(block)
			block.characteristics.chaged_active_state.connect(update_active)
			
	update_active()
	
	
	
	return blocos

func update_active():
	blocos_ativos = blocos.filter(func(b): return b.characteristics.active)

func start_game(level):
	
	update_active()
	
	level.character_spawn.blocks.clear()
	
	for b in blocos_ativos:
		level.character_spawn.blocks.append(b.characteristics)
	
		
	
	points = 0
	strikes = 0
	is_playing = true

func add_point():
	points += 1


func restart_level():
	get_tree().reload_current_scene()

func add_strike(sprite_position: Vector2):
	strikes += 1
	
	var sprite = STRIKE.instantiate()
	add_child(sprite)
	sprite.global_position = sprite_position
	sprite.z_index = 5
	
	if strikes > 2:
		#get_tree().reload_current_scene()
		is_playing = false
		game_over.emit()
		
func is_in_active(b : Blocks):
	for block in blocos_ativos:
		if b == block.characteristics:
			return true
	
	return false
	
