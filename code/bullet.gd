extends Area2D

var damage = 1
var speed = 800
var direction = Vector2.ZERO

func _ready():
	add_to_group("bullet")
	$Sprite2D.modulate = Color("#CCFF00") * 5.0
func upgrade_damage(amount):
	damage += amount

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, 150.0, 0.12)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
