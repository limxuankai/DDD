extends CharacterBody2D

const MAX_HP = 3 
const SPEED = 400.0

var hp = MAX_HP
var shoot_state = false
var beat_node = null
var experience = 0
var experience_level = 1
var collected_experience = 0

@onready var gun_tip = $GunTip
@onready var sprite = $Player
@onready var sprite2 = $Pistol
var bullet = load("res://bullet.tscn")

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("player")
	$"HealthBar".max_value = MAX_HP
	update_health_ui()
	
	$Hurtbox.hurt.connect(_on_hit)
	
	$Camera2D.enabled = true
	
	$Music.play()
	
func _process(delta):
	var time = $Music.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	print("Current position: ", time)

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func _physics_process(_delta):
	movement()

func shoot():
	var newbullet = bullet.instantiate()
	get_tree().current_scene.add_child(newbullet)
	newbullet.global_position = gun_tip.global_position
	var dir = (get_global_mouse_position() - gun_tip.global_position).normalized()
	newbullet.direction = dir

func _restart_game():
	get_tree().reload_current_scene()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov,y_mov)
	velocity = mov.normalized() * SPEED
	move_and_slide()
#region animation
	if x_mov < 0:
		sprite.flip_h = true
		sprite2.flip_h = true
		sprite2.position = Vector2(-135, -15)
		gun_tip.position = Vector2(-85, -20)
	elif x_mov > 0:
		sprite.flip_h = false
		sprite2.flip_h = false
		sprite2.position = Vector2(135, -15)
		gun_tip.position = Vector2(85, -20)
#endregion

func _on_hit(damage):
	hp -= damage
	if hp < 1:
		call_deferred("_restart_game")
	update_health_ui()

func update_health_ui():
	$"HealthBar/HealthLabel".text = "HP: %s" % hp
	$"HealthBar".value = hp

func _on_exp_collect_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
