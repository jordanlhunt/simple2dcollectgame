extends Area2D

signal Collected_PickUp(scoreValue: int)
signal Collected_Hazard(value: float)

@onready var ship_sprite: Sprite2D = get_node("ShipSprite")
@onready var thruster1: Line2D = get_node("ShipSprite/Thruster1")
@onready var thruster2: Line2D = get_node("ShipSprite/Thruster2")

var collection_count: int = 0
var draw_thrusters_limit: float = 200.0
var max_speed: float = 1000.0
var steering_factor: float = 2.0
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	HandleMovement(delta)
	HandleRotation()
	HandleWrapAround()
	HandleThrusters()

func HandleMovement(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	if direction.length() > 1.0:
		direction = direction.normalized()
	var new_velocity := max_speed * direction
	var steering := new_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta
	
func HandleRotation() -> void:
	if velocity.length() > 0.0:
		ship_sprite.rotation = (velocity.angle() - 90)

func HandleWrapAround() -> void:
	var viewPortRect: Rect2 = get_viewport_rect()
	position.x = wrapf(position.x, 0, viewPortRect.size.x)
	position.y = wrapf(position.y, 0, viewPortRect.size.y)

func HandleThrusters():
	if velocity.length() > draw_thrusters_limit:
		thruster1.visible = true
		thruster2.visible = true
	else:
		thruster1.visible = false
		thruster2.visible = false


func _on_area_entered(otherArea: Area2D) -> void:
	if otherArea.is_in_group("Pickup"):
		emit_signal("Collected_PickUp", 1)
		print_debug("Collected Pickup")
	if otherArea.is_in_group("Hazard"):
		emit_signal("Collected_Hazard", 1.5)
