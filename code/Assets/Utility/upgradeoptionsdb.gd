extends Node

const ICON_PATH = "res://Assets/Utility/Icons/Upgrades/"
const WEAPON_PATH = "res://Assets/Weapon/"
const UPGRADES = {
	"Bullets Speed": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "Faster Bullets",
		"details": "Increase Bullet Speed by 100%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"Bullets Speed 2": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "Faster Bullets",
		"details": "Increase Bullet Speed by 100%",
		"level": "Level: 2",
		"prerequisite": ["Bullets Speed"],
		"type": "upgrade"
	},
	"Bullets Speed 3": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "Faster Bullets",
		"details": "Increase Bullet Speed by 100%",
		"level": "Level: 3",
		"prerequisite": ["Bullets Speed 2"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "More Movement Speed",
		"details": "Faster movement",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "More Movement Speed",
		"details": "Faster movement",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "More Movement Speed",
		"details": "Faster movement",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"reload1": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "More Attacks",
		"details": "Increase attack speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"reload2": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "More Attacks",
		"details": "Increase attack speed",
		"level": "Level: 2",
		"prerequisite": ["reload1"],
		"type": "upgrade"
	},
	"reload3": {
		"icon": "res://Assets/Enemy/mob1.png",
		"displayname": "More Attacks",
		"details": "Increase attack speed",
		"level": "Level: 3",
		"prerequisite": ["reload2"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
	
}
