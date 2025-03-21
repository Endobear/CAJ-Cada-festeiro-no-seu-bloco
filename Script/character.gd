class_name Character
extends CharacterBody2D

const VISUAL = preload("res://Scenes/visual.tscn")
const FAT_CHARACTER_FRAMES = [preload("res://Resources/Animations/FatCharacterLight.tres"), preload("res://Resources/Animations/FatCharacterDark.tres"), preload("res://Resources/Animations/FatCharacterTan.tres")]
const SLIM_CHARACTER_FRAMES = [preload("res://Resources/Animations/SlimCharacterDark.tres"), preload("res://Resources/Animations/SlimCharacterLight.tres"), preload("res://Resources/Animations/SlimCharacterTan.tres")]





@export var characteristics : Charactersistics

@onready var block_detector: Area2D = $BlockDetector
@onready var timer: Timer = $Timer

var visual: CharacterVisual

var direction : Vector2
var speed : float = 50

var is_dragged : bool = false

var is_in_block : bool = false



func _ready() -> void:
	
	create_characteristics()
	create_character()


func _physics_process(delta: float) -> void:
	
	if !direction:
		direction = Vector2.LEFT.rotated(deg_to_rad(randf_range(-30,30)))
	
	visual.flip_h = true if direction.x < 0 else false
	
	#if (characteristics.body == Charactersistics.BODY_TYPE.SLIM and visual.sprite_frames.resource_path == FAT_CHARACTER_FRAMES.resource_path):
		#print("error")
	#if (characteristics.body == Charactersistics.BODY_TYPE.FAT and visual.sprite_frames.resource_path == SLIM_CHARACTER_FRAMES.resource_path):
		#print("error")
	
	
	if Globals.is_playing and !is_in_block and timer.time_left <= timer.wait_time/2:
		if int(timer.time_left) % 2 == 0:
			modulate = Color.from_rgba8(255,remap(timer.time_left,10,0,255,0),remap(timer.time_left,10,0,255,0))
		else:
			modulate = Color.WHITE
	
	if !is_dragged:
		if !is_in_block:
			velocity.x = move_toward(velocity.x, speed * direction.x, speed)
			velocity.y = move_toward(velocity.y, speed * direction.y, speed)
			
			
			
			move_and_slide()
			if block_detector.get_overlapping_areas():
				if block_detector.get_overlapping_areas()[0] is BlockArea and block_detector.get_overlapping_areas()[0].characteristics.active:					
					var area = block_detector.get_overlapping_areas()[0]
					direction = -global_position.direction_to(area.global_position)
					
					
					var angle_rotation = randf_range(-30,30)
					
					direction = direction.rotated(deg_to_rad(angle_rotation))
					
					
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
				global_position += global_position.direction_to(get_global_mouse_position() + mouse_offset) * delta * 5 * speed
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
	characteristics.body = [characteristics.BODY_TYPE.SLIM,characteristics.BODY_TYPE.SLIM,characteristics.BODY_TYPE.SLIM,characteristics.BODY_TYPE.FAT].pick_random()
	
	if characteristics.body == characteristics.BODY_TYPE.FAT:
		speed = speed/2


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
		
	var easter_egg = randi_range(0,100) < 1
	
	match characteristics.body:
		Charactersistics.BODY_TYPE.SLIM:
			visual.sprite_frames = SLIM_CHARACTER_FRAMES.pick_random()
			if easter_egg:
				visual.sprite_frames = preload("res://Resources/Animations/SlimCharacterTemplate.tres")
			
			if characteristics.block.slim_body_sprites:
				visual.body.sprite_frames = characteristics.block.slim_body_sprites.pick_random()
			
			if characteristics.block.slim_head_sprites:
				visual.head.sprite_frames = characteristics.block.slim_head_sprites.pick_random()
			
			if characteristics.block.slim_legs_sprites:
				visual.legs.sprite_frames = characteristics.block.slim_legs_sprites.pick_random()
			
		Charactersistics.BODY_TYPE.FAT:
			visual.sprite_frames = FAT_CHARACTER_FRAMES.pick_random()
			
			if easter_egg:
				visual.sprite_frames = preload("res://Resources/Animations/FatCharacterTemplate.tres")
			
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
			if block_detector.has_overlapping_areas():
				var b = block_detector.get_overlapping_areas()[0]
				
				if b is BlockArea:
					if b.characteristics.active:
						is_in_block = true
						# Código de detecção de tipo de bloco aqui
						var block = b
						
						if block.characteristics  == characteristics.block:
							Globals.add_point()
							visual.play(["Idle","Dancing"].pick_random())
							modulate = Color.WHITE
						else:
							Globals.add_strike(global_position)
							end_life()
							
				elif b is Lixeira:
					if not Globals.is_in_active(characteristics.block):
						Globals.add_point()
						print("point")
					else:
						Globals.add_strike(global_position)
						print("strike")
					
					end_life()

func end_life():
	queue_free()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !is_in_block:
		if event is InputEventMouseButton:
			if event.is_pressed() and !is_dragged and !Globals.dragging:
					is_dragged = true
					Globals.dragging = self


func _on_timer_timeout() -> void:
	if Globals.is_playing and not is_in_block:
		Globals.add_strike(global_position)
		end_life()
		
