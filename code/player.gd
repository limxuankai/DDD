extends CharacterBody2D

const MAX_HP = 3 
const SPEED = 400.0

var HP = MAX_HP
var bullet = load("res://bullet.tscn")
var shoot_state = false
var beat_node = null

@onready var gun_tip = $GunTip

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("player")
	update_health_ui()
	$"Health Bar".max_value = MAX_HP
	$hurtbox.hurt.connect(_on_hit)
	$receive.shoot_state.connect(_on_shoot_state)
	$Camera2D.enabled = true #Camera follow player
	
func _on_shoot_state(bn):
	if bn != null:
		shoot_state = bn.shoot_state
		beat_node = bn
	else:
		shoot_state = false
	print("Beat ready to shoot:", shoot_state)
	
func _input(event):
	if event.is_action_pressed("shoot") and shoot_state:
		shoot()
		shoot_state = false
		if beat_node != null:
			beat_node.queue_free()
	
	
func shoot():
	var newbullet = bullet.instantiate()
	get_tree().current_scene.add_child(newbullet)
	newbullet.global_position = gun_tip.global_position
	var dir = (get_global_mouse_position() - gun_tip.global_position).normalized()
	newbullet.direction = dir


func _physics_process(_delta):
	movement()

func _on_hit(damage):
	HP -= damage
	print("HP:", HP)
	if HP < 1:
		print("lose")
		call_deferred("_restart_game")
	update_health_ui()

func _restart_game():
	get_tree().reload_current_scene()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov,y_mov)
	velocity = mov.normalized() * SPEED
	move_and_slide()

func update_health_ui():
	$"Health Bar/Health Label".text = "HP: %s" % HP
	$"Health Bar".value = HP 
