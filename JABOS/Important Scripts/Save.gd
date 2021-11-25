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
	var return_data
	if data[0] == "{":
		return_data = parse_json(data) as Dictionary
	else:
		return_data = parse_json("{" + data + "}") as Dictionary
	return return_data

func pack_dict_to_string(dict : Dictionary):
	"""var final_string = ""
	for x in dict.keys():
		if typeof(dict[x]) == TYPE_STRING:
			final_string = final_string + ("\"" + x + "\"" + " : " + "\"" + str(dict[x]) + "\"" + ",\n")
		elif typeof(dict[x]) == TYPE_DICTIONARY:
			final_string = final_string + ("\"" + x + "\"" + " : {" + pack_dict_to_string(dict[x]) + "},\n")
		else:
			final_string = final_string + ("\"" + x + "\"" + " : " + str(dict[x]) + ",\n")
	print(final_string)"""
	var final_string = JSON.print(dict, "\t")
	return final_string
