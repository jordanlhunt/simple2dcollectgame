extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(enteringArea: Area2D):
	var enteringLayer = enteringArea.collision_layer
	# If the player enters delete the hazard
	if enteringLayer == 1:
		self.queue_free()
