@tool
class_name BlockArea
extends Area2D

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






func _ready():
	if shape:
		collision_shape_2d.shape = shape
		
		
func _draw() -> void:
	if not Engine.is_editor_hint():
		return
		
	if shape == null:
		return
	
	if characteristics:
		debug_color =  characteristics.cor
		
	shape.draw(get_canvas_item(), debug_color)
