extends Node

# Autoload: Highscore
# Wygenerowano automatycznie dla gry: Gra1miejsceheavenclub
const SAVE_URL = "https://godot.host736196.xce.pl/gra1miejsceheavenclub/save"
const GET_URL = "https://godot.host736196.xce.pl/gra1miejsceheavenclub/get"
const API_KEY = "8c4e64d90b67bd156f316e7a0394c615"
const GAME_SLUG = "gra1miejsceheavenclub"
var player_name = ""

# Sygnały dla łatwej obsługi w UI
signal score_submitted(result)
signal leaderboard_received(scores)
signal request_failed(error_message)

# WYSYŁANIE WYNIKU (Proste wywołanie: Highscore.send_score("Gracz1", 1250, "skin_gold"))
func send_score(player_name: String, score: int, metadata: String = "") -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(func(result, response_code, headers, body):
		http.queue_free()
		var body_str = body.get_string_from_utf8()
		var json = JSON.parse_string(body_str)
		if response_code == 200 and json is Dictionary and json.get("success", false):
			emit_signal("score_submitted", json)
		else:
			var err_msg = json.get("error", body_str) if (json is Dictionary and json.has("error")) else body_str
			emit_signal("request_failed", "Błąd zapisu (%d): %s" % [response_code, err_msg])
	)
	
	var payload = JSON.stringify({
		"game": GAME_SLUG,
		"api_key": API_KEY,
		"player_name": player_name,
		"score": score,
		"metadata": metadata
	})
	
	var headers = [
		"Content-Type: application/json",
		"X-Game-Key: " + API_KEY    ]
	
	var err = http.request(SAVE_URL, headers, HTTPClient.METHOD_POST, payload)
	if err != OK:
		emit_signal("request_failed", "Nie udało się nawiązać połączenia HTTP.")

# POBIERANIE WYNIKÓW (Wywołanie: Highscore.get_leaderboard(20))
func get_leaderboard(limit: int = 5) -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(func(result, response_code, headers, body):
		http.queue_free()
		if response_code == 200:
			var json = JSON.parse_string(body.get_string_from_utf8())
			if json and json.has("scores"):
				emit_signal("leaderboard_received", json.scores)
			else:
				emit_signal("request_failed", "Niepoprawny format danych.")
		else:
			emit_signal("request_failed", "Błąd pobierania wyników: %d" % response_code)
	)
	
	var url = GET_URL + "?limit=" + str(limit)
	http.request(url)
