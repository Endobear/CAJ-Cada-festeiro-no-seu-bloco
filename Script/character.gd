class_name Character
extends CharacterBody2D

@export var characteristics : Charactersistics

var color_rect: ColorRect

var direction : Vector2
var speed : float = 200


func _ready() -> void:
	
	create_characteristics()
	create_character()


func _process(delta: float) -> void:
	if !direction:
		direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	
	velocity.x = move_toward(velocity.x, speed * direction.x, speed)
	velocity.y = move_toward(velocity.y, speed * direction.y, speed)
	
	move_and_slide()
	
	if is_on_ceiling() || is_on_floor():
		direction.y = -direction.y
	
	if is_on_wall():
		direction.x = -direction.x


func create_character() -> void:
	create_characteristics()
	
	generate_visuals()
	
	color_rect.color = characteristics.block.cor

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
		
		
	color_rect.color = characteristics.block.cor

func generate_visuals():
	
	# hack fix, mudar pra uma função depois
	if !color_rect:
		color_rect = ColorRect.new()
		add_child(color_rect)
		color_rect.set_anchors_preset(Control.PRESET_CENTER)
		color_rect.position = Vector2(-20,-20)
		color_rect.size = Vector2(40,40)
		
	
