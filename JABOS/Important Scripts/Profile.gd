extends Node

var data = {
	"ruby" : 0,
	"level" : 1,
	"xp" : 0,
	"gamemode" : "Classic"
}
const DEFAULT_DATA = {
	"ruby" : 30,
	"level" : 1,
	"xp" : 0,
	"gamemode" : "Classic"
}

var is_cloud_game = false

var disabled_gamemodes = []

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
