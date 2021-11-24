extends Node

var game_pin = 1111
var type = 0
var running = false

var player_ids = {}

var Level = get_parent()

sync var global_data = {
	"players" : {
		1 : {"x_pos" : 0, "y_pos" : 0, "skin" : "Default", "ready" : false}
	},
	"global" : {
		"gamemode" : "Classic"
	}
}

var server_data = {
	"ip" : "127.0.0.1",
	"port" : "11110",
}

var selected_port
var selected_IP
var selected_pin

var local_player_id = 0
sync var players = {}
sync var player_data = {}

# warning-ignore:unused_signal
signal player_disconnected
# warning-ignore:unused_signal
signal server_disconnected

var server : WebSocketServer
var client : WebSocketClient


func create_game():
	#Generate game pin
	randomize()
	game_pin = int(round(rand_range(1111,9999)))
	
	server_data.ip = Profile.public_ip
	server_data.port = str(game_pin) + "0"
	Firebase.Firestore.collection("CloudGames").add(str(game_pin), server_data)
	selected_IP = server_data.ip
	selected_port = server_data.port
	
	create_server()
	
func join_game(pin):
	var collection = Firebase.Firestore.collection("CloudGames")
	collection.get(str(pin))
	collection.connect("error", self, "on_err")
	var document : FirestoreDocument = yield(collection, "get_document")
	
	server_data = document.doc_fields
	print(server_data)
	selected_IP = server_data.ip
	selected_port = server_data.port
	
	connect_to_server()

func _process(delta):
	if server != null:
		if server.is_listening():
			server.poll()
	
	if client != null:
		client.poll()


func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		if server != null:
			var collection = Firebase.Firestore.collection("CloudGames")
			collection.delete(str(game_pin))
			yield(collection, "delete_document")
		get_tree().quit()


func _ready():
	Level = get_parent()
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnect")
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	
func create_server():
	var peer = WebSocketServer.new()
	peer.listen(int(selected_port), PoolStringArray(), true)
	get_tree().network_peer = (peer)
	add_to_player_list()
	server = peer
	
	
func connect_to_server():
	selected_IP = "localhost"
	var peer = WebSocketClient.new()
	var url = "ws://" + selected_IP + ":" + str(selected_port)
	var error = peer.connect_to_url(url, PoolStringArray([]), true)
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().network_peer = (peer)
	add_to_player_list()
	client = peer
	
	
	
func add_to_player_list():
	local_player_id = get_tree().get_network_unique_id()
	player_data = {"x_pos" : 0, "y_pos" : 0, "skin" : "Default", "ready" : false}
	players[local_player_id] = player_data
	
	

func _connected_to_server():
	add_to_player_list()
	rpc("_send_player_info", local_player_id, player_data)
	


remote func _send_player_info(id, player_info):
	players[id] = player_info
	if local_player_id == 1:
		rset("players", players)
		rpc("add_player", local_player_id)

func _on_player_connected(id):
	if not get_tree().is_network_server():
		print(str(id) + " has connected.")
		
		
		
		
sync func update_waiting_room():
	print(players)



func start_game():
	rpc("load_world")
	
	
sync func add_player(playerId):
	Level.Manager.add_cloud_player(playerId)
	
	
sync func load_world():
	get_tree().change_scene("res://World/World.tscn")


