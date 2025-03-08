extends Area2D

@onready var animation: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if Globals.dragging:
		animation.play("squish_open")

func _on_body_exited(body: Node2D) -> void:
	animation.play("squish_close")
