extends Node

var dragging : Character

var blocos : Array[BlockArea]

var points : int = 0

var strikes : int = 0

const LEVEL = preload("res://Scenes/level.tscn")

var spawner


func populateBlocks(blocks : Array[Node]):
	for block in blocks:
		if block is BlockArea:
			blocos.append(block)
	
	return blocos


func start_game(level):
	points = 0
	strikes = 0


func add_point():
	points += 1
	
func add_strike():
	strikes += 1
	if strikes > 2:
		get_tree().reload_current_scene()
