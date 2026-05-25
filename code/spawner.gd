extends Node2D

@onready var enemy = load("res://enemy.tscn")
@onready var spawn_area = $ColorRect
var time = 0
var hp_multiplier = 1
var phase = 2
var spawn_rate = 0.5

func _ready():
	$Timer.autostart = true
	$Timer.one_shot = false
	$Timer.wait_time = spawn_rate
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()
	
func _process(delta):
	time += delta
	#print (time)
	if phase == 2 and time > 30:
		print("2")
		spawn_rate = 0.25
		phase += 1
	elif phase == 3 and time > 60:
		print("3")
		hp_multiplier = 2
		phase += 1
	elif phase == 4 and time > 90:
		print("4")
		hp_multiplier = 4
		phase += 1
	elif phase == 5 and time > 120:
		print("5")
		var ene = enemy.instantiate()
		ene.health = ene.health * 10
		add_child(ene)
		phase += 1




func _on_timer_timeout():
	var ene = enemy.instantiate()
	ene.health = ene.health * hp_multiplier
	var x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	ene.global_position = Vector2(x,y)
	add_child(ene)
