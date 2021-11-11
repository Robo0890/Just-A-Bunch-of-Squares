extends Node

var data = {
	"ruby" : 0,
	"level" : 1,
	"xp" : 0
}
const DEFAULT_DATA = {
	"ruby" : 30,
	"level" : 1,
	"xp" : 0
}

var current_gamemode = "Classic"

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
