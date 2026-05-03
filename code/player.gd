extends CharacterBody2D

var MAX_HP = 3 
var SPEED = 400.0
var ARMOUR = 0 
var hp = MAX_HP
var experience = 0
var experience_level = 1
var collected_experience = 0

@onready var gun_tip = $GunTip
@onready var sprite = $Player
@onready var sprite2 = $Pistol
@onready var levelup_screen = get_node("%Level_Up")
@onready var levelup_lbl = get_node("%Label_LVL_Up")
@onready var upgrade_options = get_node("%Upgrade_Options")
@onready var itemoptions = preload("res://upgrade.tscn") 
@onready var UpgradeDb = preload("res://Assets/Utility/upgradeoptionsdb.gd")

var bullet = load("res://bullet.tscn")
var bullet_speed = 800
var bullet_damage = 1

var upgrade_panel = load("res://upgrade.tscn")
var collected_upgrades = []
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
			levelup()
			$"ExpBar".value = 0

func levelup():
	$Label.text = str("Level: ",experience_level)
	var tween = levelup_screen.create_tween()
	tween.tween_property(levelup_screen,"position",Vector2(-1000,-1300),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelup_screen.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemoptions.instantiate()
		option_choice.item = get_random_item()
		upgrade_options.add_child(option_choice)
		options += 1
	get_tree().paused = true
	
func upgrade_character(upgrade):
	match upgrade:
		"armor1","armor2","armor3","armor4":
			ARMOUR += 1
		"speed1","speed2","speed3","speed4":
			SPEED += 20.0
		"food":
			hp += 20
	var option_children = upgrade_options.get_children()
	for i in option_children:
		i.queue_free()
	collected_upgrades.append(upgrade)
	levelup_screen.visible = false
	levelup_screen.position = Vector2(800,50)
	SPEED = SPEED * experience_level
	bullet_speed = bullet_speed * experience_level
	get_tree().paused = false

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check for PreRequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null
