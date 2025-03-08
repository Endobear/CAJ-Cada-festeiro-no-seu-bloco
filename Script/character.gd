class_name Character
extends CharacterBody2D
const VISUAL = preload("res://Scenes/visual.tscn")

@export var characteristics : Charactersistics
@onready var block_detector: Area2D = $BlockDetector

var visual: CharacterVisual

var direction : Vector2
var speed : float = 100

var is_dragged : bool = false

var is_in_block : bool = false



func _ready() -> void:
	
	create_characteristics()
	create_character()


func _physics_process(delta: float) -> void:
	
	if !direction:
		direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	
	if !is_dragged:
		if !is_in_block:
			velocity.x = move_toward(velocity.x, speed * direction.x, speed)
			velocity.y = move_toward(velocity.y, speed * direction.y, speed)
			
			
			
			move_and_slide()
			if block_detector.get_overlapping_areas():
				if block_detector.get_overlapping_areas()[0] is BlockArea:
					var area = block_detector.get_overlapping_areas()[0]
					direction.y = clampf(global_position.y - area.global_position.y,-1,1) 
					direction.x = clampf(global_position.x - area.global_position.x,-1,1)  
			
			visual.play("Walking")
		
			if is_on_ceiling() || is_on_floor() :
				direction.y = -direction.y
			
			if is_on_wall():
				direction.x = -direction.x
		else:
			visual.play("Idle")
			
	else:
		visual.play("Grabbed")
		velocity = Vector2.ZERO
		global_position = get_global_mouse_position()
		

func create_character() -> void:
	create_characteristics()
	
	generate_visuals()
	
	visual.color_rect.color = characteristics.block.cor

# Cria as caracteristicas do personagem caso não haja
func create_characteristics():
	if !characteristics:
		# Criar características caso não haja
		# Também verificar quais são os blocos no nível para não criar características sem bloco-
		# se for o caso do personagem não ter bloco
		characteristics = Charactersistics.new()
	characteristics.body = [characteristics.BODY_TYPE.SLIM,characteristics.BODY_TYPE.FAT].pick_random()
	


func create_character_with_block(block : Blocks) -> void:
	
	
	create_characteristics()
	
	characteristics.block = block
	
	# hack fix, mudar pra uma função depois
	generate_visuals()
		
		
	visual.color_rect.color = characteristics.block.cor

func generate_visuals():
	
	if !visual:
		visual = VISUAL.instantiate()
		add_child(visual)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed() and is_dragged:
			is_dragged = false
			global_position = event.global_position
			Globals.dragging = null
			if block_detector.has_overlapping_areas() and block_detector.get_overlapping_areas()[0] is BlockArea:
				is_in_block = true
				# Código de detecção de tipo de bloco aqui
				var block = block_detector.get_overlapping_areas()[0]
				
				if block.characteristics  == characteristics.block:
					block.ponto()
				else:
					block.strike()
					end_life()
					

func end_life():
	queue_free()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !is_in_block:
		if event is InputEventMouseButton:
			if event.is_pressed() and !is_dragged and !Globals.dragging:
					is_dragged = true
					Globals.dragging = self
