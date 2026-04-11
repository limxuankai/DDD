extends CharacterBody2D

var health = 3
var speed = 50.0
@export var experience = 1
@onready var loot_base = get_tree().get_first_node_in_group("loot")
var exp_gem = preload("res://objects/exp.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D

func _ready():
	add_to_group("enemy")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func take_damage(amount):
	health -= amount
	if health <= 0:
		death()

func death():
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child",new_gem)
	queue_free()
