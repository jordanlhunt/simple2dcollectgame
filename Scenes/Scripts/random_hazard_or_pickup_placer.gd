extends Node

@onready var timer_node: Timer = get_node("Timer")
@onready var play_scene_base_node: Node2D = get_node(".")

var itemScenes := [preload("res://Scenes/Sprites/Hazard.tscn"), preload("res://Scenes/Sprites/Star.tscn")]
var occupiedSpace := {}
const gridCellSize: Vector2 = Vector2(175, 175)

func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var itemScene: PackedScene = itemScenes.pick_random()
	var itemSceneInstance := itemScene.instantiate()
	add_child(itemSceneInstance)
	itemSceneInstance.position = find_valid_position()

func get_random_position() -> Vector2:
	var new_random_position: Vector2 = Vector2.ZERO
	var viewPort: Rect2 = play_scene_base_node.get_viewport_rect()
	new_random_position.x = randf_range(0, viewPort.size.x)
	new_random_position.y = randf_range(0, viewPort.size.y)
	return new_random_position

func find_valid_position() -> Vector2:
	var validPosition: Vector2 = get_random_position()
	var gridPosition: Vector2 = validPosition.snapped(gridCellSize)
	var maxPlacementAttempts: int = 1000
	while (gridPosition in occupiedSpace) and maxPlacementAttempts > 0:
		validPosition = get_random_position()
		gridPosition = validPosition.snapped(gridCellSize)
		maxPlacementAttempts -= 1
	if maxPlacementAttempts == 0:
		push_error("[random_hazard_or_pickup_placer.gd] - Unable to place node")
		# TODO: Find better way to place invalid position, for now just place the sprite in a far away place the player will never see
		return Vector2(-99999, -99999)
	occupiedSpace[gridPosition] = true
	# Center the image
	gridPosition.x = (gridPosition.x + (gridCellSize.x / 2.0))
	gridPosition.y = (gridPosition.y + (gridCellSize.y / 2.0))
	return gridPosition

func offset_snapped_position(gridPosition: Vector2) -> Vector2:
	var newPosition: Vector2 = gridPosition
	# Center the sprite in the cell
	newPosition.x = gridPosition.x / 2
	newPosition.y = gridPosition.y / 2
	# move the sprite in the cell a bit
	return newPosition
