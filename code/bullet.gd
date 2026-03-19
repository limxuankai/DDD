extends Area2D

@export var speed := 800
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(1)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
