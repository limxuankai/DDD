extends Area2D

signal shoot_state

func _on_area_entered(beat_node):
	if beat_node.is_in_group("beats"):
		print("enter")
		emit_signal("shoot_state", beat_node)

func _on_area_exited(beat_node):
	if beat_node.is_in_group("beats"):
		print("exit")
		emit_signal("shoot_state", null)
