extends Label

var score = 0
var cutscene_watched = false

func add():
	score += 1
	text = ":" + str(score)
