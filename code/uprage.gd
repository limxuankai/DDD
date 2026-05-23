extends Button

@onready var Name = $Label_Name
@onready var Description = $Label_Description
@onready var Level = $Label_Level
@onready var Icon = $ColorRect/Icon
@onready var UpgradeDb = preload("res://Assets/Utility/upgradeoptionsdb.gd")


var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(player, 'upgrade_character'))
	if item == null:
		item = "food"
	Name.text = UpgradeDb.UPGRADES[item]["displayname"]
	Description.text = UpgradeDb.UPGRADES[item]["details"]
	Level.text = UpgradeDb.UPGRADES[item]["level"]
	Icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func _on_my_button_pressed():
	emit_signal("selected_upgrade",item)
	print("Clicked")

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade",item)

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
