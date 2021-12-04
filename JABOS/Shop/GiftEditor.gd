extends Control

var gift_data = {
	"title" : "Title",
	"body" : "Message",
	"one_time" : true,
	"data" : {
		"type" : "ruby",
		"amount" : 0
	}
}

var random_code = "----------"

#Gift Types:
const GIFT_SKIN = 0
const GIFT_RUBY = 1

func _ready():
	gift_data = {
	"title" : "Title",
	"body" : "Message",
	"one_time" : true,
	"data" : {
		"type" : "ruby",
		"amount" : 0
	}
}

	$VBoxContainer/RubyAmount.text = "Amount: " + str(Profile.data.ruby / 2)
	$VBoxContainer/GiftType.disabled = false
	$VBoxContainer/SelectSkin.clear()
	$VBoxContainer/GiftType.select(1)
	$VBoxContainer/Title.text = "Title"
	$VBoxContainer/Message.text = "Message"
	$VBoxContainer.show()
	$Code.hide()
	if Profile.data.Owned.Skins.size() != 1:
		$VBoxContainer/GiftType.disabled = false
		for x in Profile.data.Owned.Skins:
			if x != "Default":
				$VBoxContainer/SelectSkin.add_icon_item(load("res://Images/Skins/" + x + ".png"), x)
	else:
		$VBoxContainer/GiftType.disabled = true
		$VBoxContainer/SelectSkin.hide()
		$VBoxContainer/GiftType.select(GIFT_RUBY)
	
	_on_GiftType_item_selected(1)

func _physics_process(delta):
	if visible:
		pass

func _on_GiftType_item_selected(index):
	if index == GIFT_SKIN:
		if Profile.data.Owned.Skins.size() == 1:
			OS.alert("You do not have any skins to give!")
			$VBoxContainer/GiftType.select(1)
			_on_GiftType_item_selected(1)
			return
		gift_data.data = {
			"type" : "skin",
			"name" : Profile.data.Owned.Skins[$VBoxContainer/SelectSkin.selected]
		}
		$VBoxContainer/Skin.show()
		$VBoxContainer/Ruby.hide()
		$VBoxContainer/SelectSkin.show()
		$VBoxContainer/RubyAmount.hide()
		$VBoxContainer/SelectSkin.select(0)
		_on_SelectSkin_item_selected(0)
	if index == GIFT_RUBY:
		gift_data.data = {
			"type" : "ruby",
			"amount" : 1
		}
		$VBoxContainer/Skin.hide()
		$VBoxContainer/Ruby.show()
		$VBoxContainer/SelectSkin.hide()
		$VBoxContainer/RubyAmount.show()
		#_on_RubyAmount_value_changed($VBoxContainer/RubyAmount.value)


func _on_Done_pressed():
	print(gift_data)
	if $VBoxContainer/GiftType.selected == GIFT_RUBY:
		Profile.data.ruby -= gift_data.data.amount
	if $VBoxContainer/GiftType.selected == GIFT_SKIN:
		print(Profile.data.Owned.Skins)
		Profile.data.Owned.Skins.erase(gift_data.data.name)
	
	Save.save_data(Profile.data, "jabos_profile")
	randomize()
	random_code = int(rand_range(1111111111,9999999999))
	#Firebase.Firestore.collection("Gifts").add(str(random_code))
	Firebase.Firestore.collection("Gifts").update(str(random_code), gift_data)
	
	$VBoxContainer.hide()
	$Code.show()
	$Code/Button.text = str(random_code)
	$Code/Copy.text = str(random_code)
	
	get_parent().load_shop()

func _on_SelectSkin_item_selected(index):
	gift_data.data = {
			"type" : "skin",
			"name" : Profile.data.Owned.Skins[$VBoxContainer/SelectSkin.selected + 1]
		}
	$VBoxContainer/Skin.texture = load("res://Images/Skins/" + gift_data.data.name + ".png")
	$VBoxContainer/Skin/Panel/Label.text = gift_data.data.name



func _on_Title_text_changed(new_text):
	gift_data.title = new_text


func _on_Message_text_changed(new_text):
	gift_data.body = new_text


func _on_Button_pressed():
	JavaScript.eval("""
	const shareData = {
		title: "Send Gift",
		url: "https://robo0890.github.io/Just-A-Bunch-of-Squares/Gift?code=""" + str(random_code) +""""
	}
	navigator.share(shareData)
	""")


func _on_NewGift_pressed():
	_ready()
	show()


func _on_Message_focus_entered():
	if OS.has_touchscreen_ui_hint():
		$VBoxContainer/Message.text = JavaScript.eval("prompt(\"Message:\")")
		_on_Message_text_changed($VBoxContainer/Message.text)
		


func _on_Title_focus_entered():
	if OS.has_touchscreen_ui_hint():
		$VBoxContainer/Title.text = JavaScript.eval("prompt(\"Title:\")")
		_on_Title_text_changed($VBoxContainer/Title.text)


func _on_RubyAmount_focus_entered():
	if OS.has_touchscreen_ui_hint():
		var value = int(JavaScript.eval("prompt(\"Amount:\")"))
		$VBoxContainer/RubyAmount.text = "Amount: " + str(value)
		#_on_RubyAmount_value_changed(value)


func _on_RubyAmount_text_entered(new_text):
	var value = int(new_text.split(": ")[1])
	gift_data.data = {
			"type" : "ruby",
			"amount" : value
		}
	$VBoxContainer/Ruby/Panel/Label.text = "+ " + str(gift_data.data.amount)
