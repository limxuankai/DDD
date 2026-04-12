extends Area2D

@export var experience = 1

var green_sprite = preload("res://Assets/Loot/Experience/Gem_green.png")
var blue_sprite = preload("res://Assets/Loot/Experience/Gem_blue.png")
var red_sprite = preload("res://Assets/Loot/Experience/Gem_red.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	if experience < 10:
		return
	elif experience < 100:
		sprite.texture = blue_sprite
	else:
		sprite.texture = red_sprite

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience
	
func _on_snd_collected_finished():
	queue_free()
