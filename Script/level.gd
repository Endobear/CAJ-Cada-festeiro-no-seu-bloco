extends Node2D


var dragging : bool = false

var time_elapsed : float = 0.0

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/Polygon2D

@onready var level_blocks: Node2D = $LevelBlocks

@onready var character_spawn: CharacterSpawner = $CharacterSpawn

@onready var points_label: Label = $UI/Control/Points

@onready var points_game_over_label: Label = $UI/GameOver/Panel/PointsGameOver

@onready var animation_player: AnimationPlayer = $UI/AnimationPlayer
@onready var time_label: Label = $UI/GameOver/Panel/TimerGameOver







func _ready():
	reload_blocks()
	
	time_elapsed = 0.0
	
	Globals.start_game(self)
	Globals.game_over.connect(game_over)
	
	
func _process(delta: float) -> void:
	points_label.text = tr("POINTS_TEXT") + " %02d" % Globals.points
	points_game_over_label.text = points_label.text
	time_elapsed += delta
	
func reload_blocks():
	if level_blocks.get_child_count() > 0:
		Globals.populateBlocks(level_blocks.get_children())
		for b in Globals.blocos:
			if b:
				character_spawn.blocks.append(b.characteristics)
				

func game_over():
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed,60)
	
	time_label.text = tr("TIME_TEXT") + " %01d" % minutes + " : " + "%02d" % seconds
	animation_player.play("game_over")


func _on_restart_button_up() -> void:
	Globals.restart_level()


func _on_menu_button_button_up() -> void:
	Globals.main_menu()
