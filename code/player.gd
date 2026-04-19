extends CharacterBody2D

var MAX_HP = 3 
var SPEED = 400.0

var hp = MAX_HP
var experience = 0
var experience_level = 1
var collected_experience = 0

@onready var gun_tip = $GunTip
@onready var sprite = $Player
@onready var sprite2 = $Pistol
var bullet = load("res://bullet.tscn")
var bullet_speed = 800
var bullet_damage = 1

var upgrade_panel = load("res://upgrade.tscn")

var shot_cooldown = 0.5
var time_since_last_shot = 0.0
var last_time = 0.0

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("player")
	$"HealthBar".max_value = 3
	update_health_ui()
	
	$Hurtbox.hurt.connect(_on_hit)
	
	$Camera2D.enabled = true
	
	$Music.play()

func upgrade_reload(amount):
	shot_cooldown /= amount

func upgrade_speed(amount):
	bullet_speed += amount
	
func upgrade_damage(amount):
	bullet_damage += amount

func _process(delta):
	var time = $Music.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	
	if (time < last_time):
		time_since_last_shot = 0
	
	print(time_since_last_shot , time)
	
	if time >= time_since_last_shot:
		shoot()
		time_since_last_shot = time + shot_cooldown
		last_time = time
	

func _physics_process(_delta):
	movement()

func shoot():
	var newbullet = bullet.instantiate()
	newbullet.speed = bullet_speed
	newbullet.damage = bullet_damage
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
	$"HealthBar".value = hp

func _on_exp_collect_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		$"ExpBar".value += gem_exp
		$"ExpBar".max_value = experience_level * pow(1.2 , (experience_level - 1))
		if $"ExpBar".value == $"ExpBar".max_value:
			experience_level += 1
			$Label.text = "LVL\n" + str(experience_level)
			
			#upgrade stuff
			var upgrade_panel_instance = upgrade_panel.instantiate()
			upgrade_panel_instance.global_position = Vector2(-1500, -1500)
			$Camera2D.add_child(upgrade_panel_instance)
			upgrade_panel_instance.move_to_front()
			upgrade_panel_instance.process_mode = Node.PROCESS_MODE_ALWAYS
			get_tree().paused = true
			
			$"ExpBar".value = 0

#func levelup():
	#$Label.text = str("Level: ",experience_level)
	#var tween = levelPanel.create_tween()
	#tween.tween_property(levelPanel,"position",Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	#tween.play()
	#levelPanel.visible = true
	#var options = 0
	#var optionsmax = 3
	#while options < optionsmax:
		#var option_choice = itemOptions.instantiate()
		#option_choice.item = get_random_item()
		#upgradeOptions.add_child(option_choice)
		#options += 1
	#get_tree().paused = true
	#
#func upgrade_character(upgrade):
	#match upgrade:
		#"speed1","speed2","speed3","speed4":
			#SPEED += 20.0
		#"food":
			#hp += 1
			#hp = clamp(hp,0, MAX_HP)
	#adjust_gui_collection(upgrade)
	#attack()
	#var option_children = upgradeOptions.get_children()
	#for i in option_children:
		#i.queue_free()
	#upgrade_options.clear()
	#collected_upgrades.append(upgrade)
	#levelPanel.visible = false
	#levelPanel.position = Vector2(800,50)
	#get_tree().paused = false
	#calculate_experience(0)
