extends Button
@export var menu: Control


var menu_open: bool = false
var tween: Tween

var open_x: float
var closed_x: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().process_frame
	
	var screen_width = get_viewport().get_visible_rect().size.x
	open_x = 0
	closed_x = 0.0 - menu.size.x
	menu.position.x = closed_x
	menu.visible = false
	pressed.connect(_on_shop_button_pressed)
	
	pass # Replace with function body.

func _on_shop_button_pressed() -> void:
	
	menu_open = not menu_open
	
	if tween:
		tween.kill()
	
	tween = create_tween().set_parallel(false)
	
	if menu_open:
		text = "Close Shop"
		menu.visible = true
		tween.tween_property(menu, "position:x", open_x, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		text = "Open Shop"
		tween.tween_property(menu, "position:x", closed_x, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_callback(func(): menu.visible = false)
		
