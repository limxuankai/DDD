extends Area2D

var direction = Vector2.LEFT
var speed = 1600
var shoot_state = true

func _ready():
	add_to_group("beats")

func _process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
