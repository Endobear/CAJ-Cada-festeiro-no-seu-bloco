extends Node2D

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/Polygon2D


var dragging : bool = false


func _ready() -> void:
	
	collision_polygon_2d.polygon = polygon_2d.polygon
