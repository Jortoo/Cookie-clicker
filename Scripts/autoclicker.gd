extends Button
@export var cookie_node: TextureButton
var autoclicker_aan: bool = false
var autoclick_timer: Timer

func _ready() -> void:
	pressed.connect(_toggle_autoclicker)
	
	autoclick_timer = Timer.new()
	autoclick_timer.wait_time = 0.05
	
	autoclick_timer.timeout.connect(cookie_node._on_pressed)
	
	add_child(autoclick_timer)

func _toggle_autoclicker() -> void:
	autoclicker_aan = !autoclicker_aan
	
	if autoclicker_aan:
		text = "Autoclicker: ON"
		autoclick_timer.start()
	else:
		text = "Autoclicker: OFF"
		autoclick_timer.stop()
