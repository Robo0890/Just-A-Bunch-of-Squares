extends Node

var path = "user://"

func save_data(what, where: String):
	what = pack_dict_to_string(what)
	where = path + where + ".txt"
	var file = File.new()
	file.open(where, File.WRITE)
	file.store_string(str(what))
	file.close()

func load_data(where: String):
	where = path + where + ".txt"
	var file = File.new()
	file.open(where ,File.READ)
	var data = file.get_as_text()
	file.close()
	var return_data = parse_json("{" + data + "}")
	return return_data

func pack_dict_to_string(dict : Dictionary):
	var final_string = ""
	for x in dict.keys():
		if typeof(dict[x]) == TYPE_STRING:
			final_string = final_string + ("\"" + x + "\"" + " : " + "\"" + str(dict[x]) + "\"" + ",\n")
		else:
			final_string = final_string + ("\"" + x + "\"" + " : " + str(dict[x]) + ",\n")
	return final_string
