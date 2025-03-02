class_name CharacterVisual
extends AnimatedSprite2D



@onready var color_rect: ColorRect = $ColorRect

@export var spring : float = 190
@export var damp : float = 10
@export var velocity_multiplier: float = 2.0

var last_position := Vector2.ZERO
var displacement: float = 0.0 
var velocity := Vector2.ZERO
var ocilator_velocity := 0.0

func _ready() -> void:
	if !color_rect:
		color_rect = ColorRect.new()
		add_child(color_rect)
	color_rect.set_anchors_preset(Control.PRESET_CENTER)
	color_rect.position = Vector2(-20,-20)
	color_rect.size = Vector2(40,40)
	color_rect.mouse_filter = Control.MOUSE_FILTER_PASS
	last_position = global_position

func _process(delta: float) -> void:
	if get_parent():
		var parent = get_parent() as Character
		
		if Globals.dragging == parent:
			var center_pos: Vector2 = global_position - (color_rect.size/2.0)
			
			velocity = (global_position-last_position)/delta
			last_position = global_position
			
			ocilator_velocity += velocity.normalized().x * velocity_multiplier
			
			var force = -spring * displacement - damp * ocilator_velocity
			ocilator_velocity += force * delta
			displacement += ocilator_velocity * delta
			
			rotation = displacement
			
		else:
			if rotation != 0:
				var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
				tween.tween_property(self,"rotation",0,0.1)
				
		global_position = parent.global_position
	
