extends Node

var data = {
	"ruby" : 0,
	"level" : 1,
	"xp" : 0,
	"gamemode" : "Classic",
	"Owned" : {
		"Skins" : ["Default"],
		"Power_Ups" : [],
		"Gamemodes" : ["Classic", "Space Jump"]
	}
}
const DEFAULT_DATA = {
	"ruby" : 30,
	"level" : 1,
	"xp" : 0,
	"gamemode" : "Classic",
	"Owned" : {
		"Skins" : ["Default"],
		"Power_Ups" : [],
		"Gamemodes" : ["Classic", "Space Jump"]
	},
	"version" : 1.5
}

const CURRENT_VERSION = 1.5

var is_cloud_game = false


var public_ip = "127.0.0.1"

func _process(delta):
	if data.xp >= xp_for_next_level():
		data.xp -= xp_for_next_level()
		data.level += 1

func clear():
	Save.save_data(DEFAULT_DATA, "jabos_profile")
	data = DEFAULT_DATA

func xp_for_next_level():
	var needed = data.level * 100
	return needed
