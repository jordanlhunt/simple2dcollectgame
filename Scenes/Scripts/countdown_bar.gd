extends Control

@onready var timer_node: Timer = get_node("Timer")
@onready var progress_bar_node: ProgressBar = get_node(".")
@onready var label_node: Label = get_node("Label")

const MAX_TIMER_VALUE: int = 5
var color_red: Color = Color(0.871, 0.102, 0.196)
var color_green: Color = Color(0.263, 0.701, 0.392)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar_node.max_value = MAX_TIMER_VALUE
	timer_node.wait_time = MAX_TIMER_VALUE
	timer_node.one_shot = true
	timer_node.start()
	label_node.text = "Time Left: "
	label_node.position = Vector2(progress_bar_node.size.x / 2, progress_bar_node.size.y / 2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar_node.value = timer_node.get_time_left()
	label_node.text = "Time Left: " + str(snappedi(timer_node.get_time_left(), 1))
	# If time is less than 2 seconds set the color to red else keep it green
	if (timer_node.get_time_left() <= 2):
		progress_bar_node.get("theme_override_styles/fill").bg_color = color_red
	else:
		progress_bar_node.get("theme_override_styles/fill").bg_color = color_green


func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_star_picked_up(timeBonus: float) -> void:
	timer_node.stop
	timer_node.wait_time = timer_node.get_time_left() + timeBonus
	if timer_node.wait_time >= MAX_TIMER_VALUE:
		timer_node.wait_time = MAX_TIMER_VALUE
	timer_node.start()


func _on_player_collected_hazard(value: float) -> void:
	timer_node.stop
	timer_node.wait_time = timer_node.get_time_left() - value
	if timer_node.wait_time <= 0:
		timer_node.wait_time = 0
		timer_node.stop()
		return
	timer_node.start()
