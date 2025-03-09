@tool
class_name BlockArea
extends Area2D

const BANNER = preload("res://Assets/Sprites/Props/Blocos/banner.png")
const MASTRO = preload("res://Assets/Sprites/Props/Blocos/mstro.png")

const CONSTRUCTION_PROPS = [preload("res://Assets/Sprites/Props/Blocos/Vazio/caixa1.png"), preload("res://Assets/Sprites/Props/Blocos/Vazio/caixa2.png"), preload("res://Assets/Sprites/Props/Blocos/Vazio/caixas1.png"), preload("res://Assets/Sprites/Props/Blocos/Vazio/caixas2.png"), preload("res://Assets/Sprites/Props/Blocos/Vazio/em breve.png"), preload("res://Assets/Sprites/Props/Blocos/Vazio/ferramentas.png"), preload("res://Assets/Sprites/Props/Blocos/Vazio/pregos.png")]

var props_spawned : Array[Sprite2D]

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
	Globals.add_strike(global_position)


func _ready():
	if shape:
		collision_shape_2d.shape = shape
		
	if Engine.is_editor_hint():
		return
	
	if characteristics and characteristics.active == true:
		characteristics.chaged_active_state.connect(update_active_props)
		spawn_props()
		spawn_banner()
		
	else:
		if characteristics:
			characteristics.chaged_active_state.connect(update_active_props)
		spawn_props_inactive()




func spawn_props_inactive():
	if props_spawned:
		for p in props_spawned:
			p.queue_free()
		props_spawned.clear()
	if !characteristics or characteristics.active == false:
		var construction_props = CONSTRUCTION_PROPS.duplicate()
		for prop in construction_props:
			prop = construction_props.pick_random()
			construction_props.erase(prop)
			prop_spawn(prop)



func spawn_props():
	if props_spawned:
		for p in props_spawned:
			p.queue_free()
		props_spawned.clear()
	
	if characteristics and characteristics.active == true:
		if characteristics.props.size() > 0:
			var props = characteristics.props.duplicate()
			for i in range(clamp(props.size(),1,4)):
				var prop = props.pick_random()
				props.erase(prop)
				prop_spawn(prop)


func spawn_banner():
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
	
	props_spawned.append(mastro)
	props_spawned.append(banner)
	props_spawned.append(simbol)
		
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
	props_spawned.append(sprite)


func update_active_props():
	if characteristics:
		if characteristics.active:
			spawn_props()
			spawn_banner()
		else:
			spawn_props_inactive()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return
		
	if shape == null:
		return
	
	if characteristics:
		debug_color =  characteristics.cor
		
	shape.draw(get_canvas_item(), debug_color)
