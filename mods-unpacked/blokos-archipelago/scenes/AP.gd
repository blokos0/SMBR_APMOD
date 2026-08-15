extends Node
var socket: WebSocketPeer = WebSocketPeer.new()
var address: String
var password: String
var slot_name: String
var slot_id: int
var slot_data: Dictionary
var team: float
var players: Array
var connected: bool
var checked_locations: PackedInt64Array
var seed_name: String
var version: Dictionary = {"major": 0, "minor": 6, "build": 6, "class": "Version"}
var remote_version: Dictionary
var data_packages: Dictionary
var location_id_to_name: Dictionary
var item_id_to_name: Dictionary
var playing: bool
var my_game: String = "Super Mario Bros. Remastered"
var inventory: Array
func _ready() -> void:
	socket.inbound_buffer_size = 65536 * 128
	await get_tree().create_timer(2, false).timeout # debug
	connectserver("localhost:38281", "", "testguy")
func connectserver(add: String, pas: String, slot: String) -> void:
	address = add
	password = pas
	slot_name = slot
	var err: Error = socket.connect_to_url(address)
	if !err:
		connected = true
		Global.log_comment("Connecting...")
		# AudioManager.play_global_sfx("beep")
	else:
		AudioManager.play_global_sfx("bump")
		if err == ERR_ALREADY_IN_USE:
			socket.close()
			connected = false
			playing = false
			Global.log_comment("Disconnected!")
		else:
			Global.log_error(error_string(err))
func _physics_process(_delta: float) -> void:
	if connected:
		socket.poll()
		var state: int = socket.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count():
				var packet: PackedByteArray = socket.get_packet()
				if socket.was_string_packet():
					var json: Dictionary = JSON.parse_string(packet.get_string_from_utf8())[0]
					print("{=======================")
					print(json)
					print("}=======================")
					parse_message(json)
	#print(str(Global.world_num) + "-" + str(Global.level_num))
func parse_message(json: Dictionary) -> void:
	match json["cmd"]:
		"RoomInfo":
			seed_name = json["seed_name"]
			remote_version = json["version"]
			var needed_games: PackedStringArray
			for game: String in json["datapackage_checksums"].keys():
				if !data_packages.has(game) || data_packages[game]["checksum"] != json["datapackage_checksums"][game]:
					needed_games.append(game)
			if needed_games.is_empty():
				connect_to_room()
			else:
				send_message({"cmd": "GetDataPackage", "games": needed_games})
				for game: String in needed_games:
					data_packages[game] = {}
					data_packages[game]["checksum"] = json["datapackage_checksums"][game]
		"DataPackage":
			for game: String in json["data"]["games"].keys():
				data_packages[game]["location_name_to_id"] = json["data"]["games"][game]["location_name_to_id"]
				data_packages[game]["item_name_to_id"] = json["data"]["games"][game]["item_name_to_id"]
				for x: String in data_packages[game]["location_name_to_id"].keys():
					location_id_to_name[data_packages[game]["location_name_to_id"][x]] = x # crimes
				for y: String in data_packages[game]["item_name_to_id"].keys():
					item_id_to_name[data_packages[game]["item_name_to_id"][y]] = y
			var file: FileAccess = FileAccess.open("user://AP_DATAPACKAGES.txt", FileAccess.WRITE)
			file.store_var(data_packages)
			file.close()
			connect_to_room()
		"ConnectionRefused":
			Global.log_error("Connection refused: " + ", ".join(json["errors"]))
			AudioManager.play_global_sfx("bump")
			connected = false
			playing = false
			socket.close()
		"Connected":
			playing = true
			team = json["team"]
			slot_id = json["slot"]
			players = json["players"]
			checked_locations = json["checked_locations"]
			if json["missing_locations"] == []:
				send_message({"cmd": "StatusUpdate", "status": 30})
			slot_data = json["slot_data"]
			Global.log_comment("Connected!")
			AudioManager.play_global_sfx("coin")
			print(slot_data["starting_world"])
			var ass: String = "0000000000000000000000000000000000000000000000000000"
			ass = ass.erase((slot_data["starting_world"] - 1) * 4, 4)
			ass = ass.insert((slot_data["starting_world"] - 1) * 4, "1111")
			SaveManager.visited_levels = ass
			send_message({"cmd": "Sync"})
		"PrintJSON":
			if !["ItemSend"].has(json.get("type", "Meow")):
				return
			var text: String = ""
			for t: Dictionary in json["data"]:
				var part: String
				if !t.has("type"):
					part = t["text"]
				else:
					match t["type"]:
						"player_id":
							part = players[int(t["text"]) - 1]["alias"]
						"item_id":
							part = item_id_to_name[float(t["text"])]
						"location_id":
							part = location_id_to_name[float(t["text"])]
				text += part
			Global.log_comment(text)
		"ReceivedItems":
			for i: Dictionary in json["items"]:
				var item_name: String = item_id_to_name[i["item"]]
				print(item_name)
				if item_name.begins_with("World"):
					var world: int = int(item_name.get_slice(" ", 1))
					var ass: String = SaveManager.visited_levels
					ass = ass.erase((world - 1) * 4, 4)
					ass = ass.insert((world - 1) * 4, "1111")
					SaveManager.visited_levels = ass
		"RoomUpdate":
			pass
		_:
			Global.log_warning("Unknown command: " + json["cmd"])
func send_message(msg: Dictionary) -> void:
	socket.send_text(JSON.stringify([msg]))
func check(level: String) -> void:
	send_message({"cmd": "LocationChecks", "locations": [data_packages[my_game]["location_name_to_id"][level]]})
func connect_to_room() -> void:
	send_message({
		"cmd": "Connect",
		"password": password,
		"game": my_game,
		"name": slot_name,
		"uuid": "SMB1R" + slot_name,
		"version": version,
		"items_handling": 0b111,
		"tags": ["AP", "SMB1R"],
		"slot_data": true
	})
