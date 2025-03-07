extends Node

var dragging : Character

var blocos : Array[BlockArea]

func populateBlocks(blocks : Array[Node]):
	for block in blocks:
		if block is BlockArea:
			blocos.append(block)
	
	return blocos
