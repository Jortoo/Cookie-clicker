extends Node

@onready var bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _update_bar() -> void:
	
	bar.min_value = 0
	bar.max_value = Global.exp
	bar.value = Global.xp


	pass
