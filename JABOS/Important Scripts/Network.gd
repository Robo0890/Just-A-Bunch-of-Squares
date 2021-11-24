extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 32032
const MAX_PLAYERS = 4

var selected_port = 32032
var selected_IP
var selected_pin

var player_count
var spawn_id = 0
var local_player_id = 0
sync var players = {}
sync var player_data = {}
sync var scores = {}

signal player_disconnected
signal server_disconnected

var networkPeer = null
var crypto
var key
var cert


sync func set_score(playerid, value, pname = null):
	var s = scores
	if pname != null:
		s[str(playerid)] = {}
		s[str(playerid)].player_name = pname
	s[str(playerid)].score = value
	rset("scores", s)



func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		if get_tree().root.get_child(3).get_script() != null:
			get_tree().root.get_child(3).on_quit()
		else:
			get_tree().quit()
		
func server_lost():
	get_tree().quit()

func _ready():
	#get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("server_disconnected", self, "server_lost")
	#crypto = Crypto.new()
	#key = crypto.generate_rsa(4096)
	#cert = crypto.generate_self_signed_certificate(key)

	
	
func _process(delta):
	if networkPeer != null:
		if true:
			if get_tree().get_network_unique_id() == 1:
				if networkPeer.is_listening(): # is_listening is true when the server is active and listening
					networkPeer.poll()
			else:
				if (networkPeer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED ||
					networkPeer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
						networkPeer.poll()
	
func create_server():
	if true:
		var server = WebSocketServer.new()
		#server.private_key = key
		#server.ssl_certificate = cert
		server.listen(selected_port, PoolStringArray(), true)
		get_tree().set_network_peer(server)
		add_to_player_list()
		networkPeer = server
	else:
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(selected_port, MAX_PLAYERS)
		get_tree().set_network_peer(peer)
		add_to_player_list()
		networkPeer = peer

	
func connect_to_server():
	if true:
		var client = WebSocketClient.new()
		get_tree().connect("connected_to_server", self, "_connected_to_server")
		#client.trusted_ssl_certificate = cert
		var url = "ws://" + selected_IP + ":" + str(selected_port) 
		var error = client.connect_to_url(url, PoolStringArray(), true)
		get_tree().set_network_peer(client)
		add_to_player_list()
		networkPeer = client

		
	
func add_to_player_list():
	local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = player_data
	
	

func _connected_to_server():
	add_to_player_list()
	rpc("_send_player_info", local_player_id, player_data)
	


remote func _send_player_info(id, player_info):
	players[id] = player_info
	if local_player_id == 1:
		rset("players", players)
		rpc("update_waiting_room")



sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)



func start_game():
	rpc("load_world")
	
	
	
	
sync func load_world():
	print("start game")




