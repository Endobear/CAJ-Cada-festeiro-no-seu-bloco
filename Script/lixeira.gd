class_name Lixeira
extends Area2D

@onready var animation: AnimationPlayer = $AnimationPlayer



func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if Globals.dragging:
		animation.play("squish_open")


func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	animation.play("squish_close")
