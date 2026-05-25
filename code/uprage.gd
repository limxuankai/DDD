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
	if item == null:
		item = "food"
	Name.text = UpgradeDb.UPGRADES[item]["displayname"]
	Description.text = UpgradeDb.UPGRADES[item]["details"]
	Level.text = UpgradeDb.UPGRADES[item]["level"]
	Icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])
	connect("selected_upgrade", Callable(player, 'upgrade_character'))

func _on_pressed() -> void:
	emit_signal("selected_upgrade",item)
	print("Clicked")
