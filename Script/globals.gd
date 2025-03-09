extends Node

var dragging : Character

var blocos : Array[BlockArea]
var blocos_ativos : Array[BlockArea]

var points : int = 0

var strikes : int = 0

const LEVEL = preload("res://Scenes/level.tscn")

var spawner


func populateBlocks(blocks : Array[Node]):
	blocos.clear()
	
	for block in blocks:
		if block is BlockArea:
			blocos.append(block)
	
	blocos_ativos = blocos.filter(func(b): return b.characteristics.active)
	
	
	
	return blocos


func start_game(level):
	
	level.character_spawn.blocks.clear()
	
	for b in blocos_ativos:
		level.character_spawn.blocks.append(b.characteristics)
		
	points = 0
	strikes = 0


func add_point():
	points += 1
	
func add_strike():
	strikes += 1
	if strikes > 2:
		get_tree().reload_current_scene()
		
func is_in_active(b : Blocks):
	for block in blocos_ativos:
		if b == block.characteristics:
			return true
	
	return false
	
