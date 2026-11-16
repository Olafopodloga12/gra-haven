extends Label

var score = 0
var cutscene_watched = false
var volum = 25

func add():
	score += 1
	text = ":" + str(score)
