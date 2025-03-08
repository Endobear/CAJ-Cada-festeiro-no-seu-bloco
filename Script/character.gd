class_name Character
extends CharacterBody2D

const VISUAL = preload("res://Scenes/visual.tscn")
const FAT_CHARACTER_FRAMES = preload("res://Resources/Animations/FatCharacter.tres")
const SLIM_CHARACTER_FRAMES = preload("res://Resources/Animations/SlimCharacter.tres")

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
		direction = Vector2.RIGHT.rotated(rad_to_deg(randf_range(0,360)))
	
	visual.flip_h = true if direction.x < 0 else false
	
	#if (characteristics.body == Charactersistics.BODY_TYPE.SLIM and visual.sprite_frames.resource_path == FAT_CHARACTER_FRAMES.resource_path):
		#print("error")
	#if (characteristics.body == Charactersistics.BODY_TYPE.FAT and visual.sprite_frames.resource_path == SLIM_CHARACTER_FRAMES.resource_path):
		#print("error")
	
	if !is_dragged:
		if !is_in_block:
			velocity.x = move_toward(velocity.x, speed * direction.x, speed)
			velocity.y = move_toward(velocity.y, speed * direction.y, speed)
			
			
			
			move_and_slide()
			if block_detector.get_overlapping_areas():
				if block_detector.get_overlapping_areas()[0] is BlockArea:
					var area = block_detector.get_overlapping_areas()[0]
					direction = -global_position.direction_to(area.global_position)
					direction.rotated(deg_to_rad(randf_range(-30,30)))
			
			visual.play("Walking")
		
			if is_on_ceiling() || is_on_floor() :
				direction.y = -direction.y
			
			if is_on_wall():
				direction.x = -direction.x
		
			
			
	else:
		visual.play("Grabbed")
		velocity = Vector2.ZERO
		
		if characteristics.body == Charactersistics.BODY_TYPE.SLIM:
			
			global_position = get_global_mouse_position() + Vector2(0,14)
		else:
			#global_position.x = move_toward(global_position.x, get_global_mouse_position().x, 2 * speed * delta) 
			#global_position.y = move_toward(global_position.y, get_global_mouse_position().y, 2 * speed * delta) 
			
			
			var mouse_offset = Vector2(3,15) if !visual.flip_h else Vector2(-3,15)
			
			if global_position.distance_to(get_global_mouse_position() + mouse_offset) > 2:
				global_position += global_position.direction_to(get_global_mouse_position() + mouse_offset) * delta * 2 * speed
			else:
				global_position = get_global_mouse_position() + mouse_offset
			
			
func create_character() -> void:
	if not characteristics:
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
	
	if not characteristics:
		create_characteristics()
	
	characteristics.block = block
	
	# hack fix, mudar pra uma função depois
	generate_visuals()
		
	
	visual.color_rect.color = characteristics.block.cor

func generate_visuals():
	
	if !visual:
		visual = VISUAL.instantiate()
		add_child(visual)
		
		
	match characteristics.body:
		Charactersistics.BODY_TYPE.SLIM:
			visual.sprite_frames = SLIM_CHARACTER_FRAMES
			
			if characteristics.block.slim_body_sprites:
				visual.body.sprite_frames = characteristics.block.slim_body_sprites.pick_random()
			if characteristics.block.slim_head_sprites:
				visual.head.sprite_frames = characteristics.block.slim_head_sprites.pick_random()
			if characteristics.block.slim_legs_sprites:
				visual.legs.sprite_frames = characteristics.block.slim_legs_sprites.pick_random()
			
		Charactersistics.BODY_TYPE.FAT:
			visual.sprite_frames = FAT_CHARACTER_FRAMES
			
			if characteristics.block.fat_body_sprites:
				visual.body.sprite_frames = characteristics.block.fat_body_sprites.pick_random()
				
			if characteristics.block.fat_head_sprites:
				visual.head.sprite_frames = characteristics.block.fat_head_sprites.pick_random()
				
			if characteristics.block.fat_legs_sprites:
				visual.legs.sprite_frames = characteristics.block.fat_legs_sprites.pick_random()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed() and is_dragged:
			is_dragged = false
			if characteristics.body == Charactersistics.BODY_TYPE.SLIM:
				global_position = event.global_position + Vector2(0,14)
				
			Globals.dragging = null
			if block_detector.has_overlapping_areas() and block_detector.get_overlapping_areas()[0] is BlockArea:
				is_in_block = true
				# Código de detecção de tipo de bloco aqui
				var block = block_detector.get_overlapping_areas()[0]
				
				if block.characteristics  == characteristics.block:
					block.ponto()
					visual.play(["Idle","Dancing"].pick_random())
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
