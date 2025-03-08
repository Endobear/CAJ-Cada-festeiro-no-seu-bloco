@tool
class_name BlockArea
extends Area2D

const BANNER = preload("res://Assets/Sprites/Props/Blocos/banner.png")
const MASTRO = preload("res://Assets/Sprites/Props/Blocos/mstro.png")


@export var characteristics : Blocks

@export var debug_color : Color = Color.DARK_BLUE


@export var shape:Shape2D:
	set(new_value):
		if shape == new_value:
			return

		if shape != null and shape.changed.is_connected(queue_redraw):
			shape.changed.disconnect(queue_redraw)

		shape = new_value
		if shape != null and not shape.changed.is_connected(queue_redraw):
			shape.changed.connect(queue_redraw)

		queue_redraw()
		
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



func ponto():
	Globals.add_point()
	
func strike():
	Globals.add_strike()


func _ready():
	if shape:
		collision_shape_2d.shape = shape
		
	if Engine.is_editor_hint():
		return
		
	if characteristics.props.size() > 0:
		for i in range(clamp(characteristics.props.size(),1,4)):
			var prop = characteristics.props.pick_random()
			characteristics.props.erase(prop)
			prop_spawn(prop)
	
	
	var mastro = Sprite2D.new()
	add_child(mastro)
	mastro.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	mastro.texture = MASTRO
	mastro.self_modulate = characteristics.cor
	mastro.position.x = shape.get_rect().position.x + mastro.texture.get_width()
	mastro.position.y = shape.get_rect().position.y
	
	
	var banner = Sprite2D.new()
	mastro.add_child(banner)
	banner.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	banner.texture = BANNER
	banner.self_modulate = characteristics.cor
	banner.z_index = 2
	
	var simbol = Sprite2D.new()
	banner.add_child(simbol)
	simbol.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	simbol.texture = characteristics.simbol
		
func prop_spawn(prop : Texture2D):
	var sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.texture = prop
	sprite.flip_h = randi_range(0,1)
	# Pega um ponto aleatório dentro da area do bloco
	var x = randf_range(shape.get_rect().position.x + prop.get_width(), shape.get_rect().position.x+ (shape.get_rect().size.x - prop.get_width()))
	var y = randf_range(shape.get_rect().position.y + prop.get_height(), shape.get_rect().position.y+ (shape.get_rect().size.y - prop.get_height()))
	
	sprite.position = Vector2(x,y)

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
		
	if shape == null:
		return
	
	if characteristics:
		debug_color =  characteristics.cor
		
	shape.draw(get_canvas_item(), debug_color)
