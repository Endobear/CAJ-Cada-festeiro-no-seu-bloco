extends Node2D

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/Polygon2D

@onready var level_blocks: Node2D = $LevelBlocks

@onready var character_spawn: CharacterSpawner = $CharacterSpawn


var dragging : bool = false




func _ready():
	reload_blocks()
	
	Globals.start_game(self)
	
func reload_blocks():
	if level_blocks.get_child_count() > 0:
		Globals.populateBlocks(level_blocks.get_children())
		for b in Globals.blocos:
			if b:
				character_spawn.blocks.append(b.characteristics)
				
