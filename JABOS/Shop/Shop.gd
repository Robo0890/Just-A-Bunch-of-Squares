extends Control


onready var Level = get_parent().get_parent()
onready var GUI = Level.GUI

var online_shop

#Daily Skin
var daily_skin


var weekday

func _ready():
	var time = OS.get_datetime()
	var dayofweek = time["weekday"]
	match dayofweek:
		0:
			weekday = "sunday"
		1:
			weekday = "monday"
		2:
			weekday = "tuesday"
		3:
			weekday = "wednesday"
		4:
			weekday = "thursday"
		5:
			weekday = "friday"
		6:
			weekday = "saturday"

	$Loading.show()
	$Body.hide()
	$Head.hide()
	online_shop = Firebase.Firestore.collection("Shop")
	online_shop.get(str(weekday))
	var get_skins : FirestoreDocument = yield(online_shop, "get_document")
	$Loading.hide()
	$Body.show()
	$Head.show()
	online_shop = get_skins.doc_fields
	
	daily_skin = online_shop.skin
	$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/SkinName.text = daily_skin.name
	$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.text = str(daily_skin.price)
	$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/TextureRect.texture = load("res://Images/Skins/" + daily_skin.name + ".png")
	
	load_shop()

func load_shop():
	
	#***Daily Skin***
	if daily_skin.price == 0:
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.text = "Free!"
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.add_color_override("font_color", Color.green)
	
	if Profile.data.ruby - daily_skin.price < 0:
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.disabled = true
	
	if Profile.data.Owned.Skins.has(daily_skin.name):
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.hide()
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Owned.show()
		
	if daily_skin.has("deal"):
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Deal.show()
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Deal.text = daily_skin.deal
	
	
	#***Head***
	$Head/HBoxContainer/Rubies.text = str(Profile.data.ruby)
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar/Level/Label.text = "Level " + str(Profile.data.level)
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar.max_value = Profile.xp_for_next_level()
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar.value = Profile.data.xp
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar/Level/XP.text = "XP " + str(Profile.data.xp) + "/" + str(Profile.xp_for_next_level())



func _on_Back_pressed():
	GUI.is_shop_visible = false
	GUI.show()
	GUI.GamemodeBox.select(0)
	queue_free()



func _on_Skin_Buy_pressed():
	Profile.data.Owned.Skins.append(daily_skin.name)
	Profile.data.ruby -= daily_skin.price
	Save.save_data(Profile.data, "jabos_profile")
	load_shop()


func _on_Clear_pressed():
	Profile.clear()
	load_shop()


func _on_GiftCode_text_entered(new_text):
	var collection = Firebase.Firestore.collection("Gifts")
	collection.get(new_text)
	collection.connect("error", self, "invalid_gift_code")
	var gift : Dictionary = yield(collection, "get_document").doc_fields
	
	if gift != null:
		$Body.hide()
		$Gift.show()
		$Gift/VBoxContainer/Title.text = gift.title
		$Gift/VBoxContainer/Message.text = gift.body
		match gift.data.type:
			"skin":
				$Gift/VBoxContainer/Skin.texture = load("res://Images/Skins/" + gift.data.name + ".png")
				$Gift/VBoxContainer/Skin.show()
				$Gift/VBoxContainer/Skin/Panel/Label.text = gift.data.name + " Skin"
				if !Profile.data.Owned.Skins.has(gift.data.name):
					Profile.data.Owned.Skins.append(gift.data.name)
				else:
					gift.one_time = false
			"ruby":
				$Gift/VBoxContainer/Ruby/Panel/Label.text = "+ " + str(gift.data.amount)
				$Gift/VBoxContainer/Ruby.show()
				Profile.data.ruby += gift.data.amount
				
		Save.save_data(Profile.data, "jabos_profile")
		load_shop()
		if gift.one_time:
			collection.delete(new_text)



func _on_Ok_pressed():
	$Gift.hide()
	$Gift/VBoxContainer/Ruby.hide()
	$Gift/VBoxContainer/Skin.hide()
	$Body.show()
	$Body/Panel/MarginContainer/HSplitContainer/Skins/GiftCode.text = ""

func invalid_gift_code(q, w, e):
	OS.alert("Code Invalid", "Oops!")


func _on_GiftCode_focus_entered():
	OS.show_virtual_keyboard()
	"""if OS.has_virtual_keyboard():
		$Body/Panel/MarginContainer/HSplitContainer/Skins/GiftCode.text = JavaScript.eval("prompt(\"Enter Code\")")
		_on_GiftCode_text_entered($Body/Panel/MarginContainer/HSplitContainer/Skins/GiftCode.text)
		"""
