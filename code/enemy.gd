extends CharacterBody2D

var health = 3
var speed = 50.0
@export var experience = 1
@onready var loot_base = get_tree().get_first_node_in_group("loot")
var exp_gem = preload("res://objects/exp.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var flash_tween: Tween

func _ready():
	add_to_group("enemy")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta):
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		movement()
	move_and_slide()

func take_damage(amount):
	health -= amount
	_start_white_flash()
	if health <= 0:
		death()

func death():
	$CollisionShape2D.set_deferred("disabled", true)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free()

func movement():
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	
func _start_white_flash():
	# If a flash is already happening, stop it to reset the color
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
		# Immediately reset to normal before starting new flash
		sprite.modulate = Color.WHITE 

	# 1. Instantly make the sprite glow white
	# Using a value > 1 creates the bright "blown out" look [citation:8][citation:9]
	sprite.modulate = Color(10, 10, 10)

	# 2. Create a new tween to animate the color back to normal
	flash_tween = create_tween()
	# Add easing to make the transition smooth (it starts fast and settles gently)
	flash_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	# 3. Animate the modulate property back to white (normal color) over 0.3 seconds
	flash_tween.tween_property(sprite, "modulate", Color.WHITE, 0.3)
