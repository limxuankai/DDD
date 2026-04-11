extends Node2D

@onready var beat = load("res://beat.tscn")
	
func _ready():
	$Timer.autostart = true
	$Timer.one_shot = false
	$Timer.wait_time = 0.5
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	var bt = beat.instantiate()
	bt.global_position = Vector2(0,0)
	add_child(bt)
