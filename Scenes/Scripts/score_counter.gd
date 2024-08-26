extends TextEdit


var currentScore: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Score: "
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Score: " + str(currentScore)


func _on_player_collected_pick_up(scoreValue: int) -> void:
	currentScore += scoreValue
	print_debug("Current Score: ", currentScore)
