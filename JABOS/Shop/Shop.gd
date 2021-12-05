extends Control


onready var Level = get_parent().get_parent()
onready var GUI = Level.GUI

var collection = Firebase.Firestore.collection("Gifts")

var online_shop

#Daily Skin
var daily_skin


var weekday

func _ready():
	collection.connect("error", self, "invalid_gift_code")
	
	$Debug.text = str(Profile.data)
	
	$Head/HBoxContainer/Back.grab_focus()
	
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
	
	$GiftEditor.hide()
	$Profile.hide()
	$Loading.show()
	$Body.hide()
	$Head.show()
	load_head()
	
	online_shop = Firebase.Firestore.collection("Shop")
	online_shop.get(str(weekday))
	var get_skins : FirestoreDocument = yield(online_shop, "get_document")
	$Loading.hide()
	$Body.show()
	$Head.show()
	online_shop = get_skins.doc_fields
	
	daily_skin = online_shop.skin
	
	
	load_shop()
	
	if Profile.gift_link != "":
		_on_GiftCode_text_entered(Profile.gift_link)
		Profile.gift_link = ""

func load_shop():
	
#   ***Daily Skin***
	$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/SkinName.text = daily_skin.name
	$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.text = str(daily_skin.price)
	$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/TextureRect.texture = load("res://Images/Skins/" + daily_skin.name + ".png")
	
	if daily_skin.price == 0:
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.text = "Free!"
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.add_color_override("font_color", Color.green)
	
	if Profile.data.ruby - daily_skin.price < 0:
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.disabled = true
	else:
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.disabled = false
	
	if Profile.data.Owned.Skins.has(daily_skin.name):
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.hide()
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Owned.show()
	else:
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Buy.show()
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Owned.hide()
		
	if daily_skin.has("deal"):
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Deal.show()
		$Body/Panel/MarginContainer/HSplitContainer/Skins/DailySkin/Deal.text = daily_skin.deal
	
	
#   ***Head***
	load_head()

func load_head():
	$Head/HBoxContainer/Rubies.text = str(Profile.data.ruby)
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar/Level/Label.text = "Level " + str(Profile.data.level)
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar.max_value = Profile.xp_for_next_level()
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar.value = Profile.data.xp
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar/Level/XP.text = "XP " + str(Profile.data.xp) + "/" + str(Profile.xp_for_next_level())

func _on_Back_pressed():
	match $Head/HBoxContainer/Back.text:
		"Shop":
			GUI.ui_focus = "Options"
			GUI.show()
			GUI.GamemodeBox.select(0)
			GUI._on_Button_pressed()
			queue_free()
		"Profile":
			$Head/HBoxContainer/Back.text = "Shop"
			$Profile.hide()
			$Body.show()
		"Send Gift":
			$Body.show()
			$GiftEditor.hide()
			$Head/HBoxContainer/Back.text = "Shop"



func _on_Skin_Buy_pressed():
	Profile.data.Owned.Skins.append(daily_skin.name)
	Profile.data.ruby -= daily_skin.price
	Save.save_data(Profile.data, "jabos_profile")
	load_shop()


func _on_Clear_pressed():
	Profile.clear()
	load_shop()
	_on_Back_pressed()


func _on_GiftCode_text_entered(new_text):
	collection.get(new_text)
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
	yield($Gift/VBoxContainer/Ok, "pressed")
	$Gift.hide()
	$Gift/VBoxContainer/Ruby.hide()
	$Gift/VBoxContainer/Skin.hide()
	$Body.show()
	$Body/Panel/MarginContainer/HSplitContainer/Skins/GiftCode.text = ""





func invalid_gift_code(q, w, e):
	OS.alert("Code Invalid", "Oops!")


func _on_GiftCode_focus_entered():
	if OS.has_touchscreen_ui_hint():
		$Body/Panel/MarginContainer/HSplitContainer/Skins/GiftCode.text = JavaScript.eval("prompt(\"Enter Code:\")")
		_on_GiftCode_text_entered($Body/Panel/MarginContainer/HSplitContainer/Skins/GiftCode.text)
		


func _on_Profile_pressed():
	Profile.data.stats.skins_owned = Profile.data.Owned.Skins.size()
	$Profile/Panel/MarginContainer/VBoxContainer/Stats/Jumps.text = "Total Jumps: " + str(Profile.data.stats.jumps)
	$Profile/Panel/MarginContainer/VBoxContainer/Stats/Falls.text = "Total Falls: " + str(Profile.data.stats.falls)
	$Profile/Panel/MarginContainer/VBoxContainer/Stats/Games.text = "Games Played: " + str(Profile.data.stats.games)
	$Profile/Panel/MarginContainer/VBoxContainer/Stats/Skins.text = "Skins Owned: " + str(Profile.data.stats.skins_owned)
	$Profile/Panel/MarginContainer/VBoxContainer/Stats/Favorite.text = "Favorite Skin: " + str(Profile.data.stats.favorite)
	$Body.hide()
	$Profile.show()
	$Head/HBoxContainer/Back.text = "Profile"


func _on_Send_pressed():
	$Body.hide()
	$GiftEditor.show()
	$Head/HBoxContainer/Back.text = "Send Gift"





func _on_Cancel_pressed():
	_on_Back_pressed()
