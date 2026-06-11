extends Button

@export var close_button: Button
@export var stats_menu: PanelContainer

@export var total_clicks: Label
@export var total_cookies: Label
@export var current_cookies: Label
@export var cps_multi: Label
@export var cpc_multi: Label
@export var crit_chance: Label
@export var crit_multi: Label
@export var prestige: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	stats_menu.visible = false
	close_button.pressed.connect(func(): _close_menu())
	pressed.connect(func(): _open_menu())
	pass # Replace with function body.

func _refresh_stats() -> void:
	total_clicks.text = "Clicks: %s " % Global.format_num(Global.clicks)
	total_cookies.text = "Lifetime Cookies: %s " % Global.format_num(int(Global.total_cookies))
	current_cookies.text = "Cookies: %s " % Global.format_num(int(Global.cookies))
	
	cps_multi.text = "Cps Multi: " + str(snapped(Global.seconds_multi, 0.01)) + "x"
	cpc_multi.text = "Cpc Multi: " + str(snapped(Global.click_multi, 0.01)) + "x"
	
	crit_chance.text = "Crit Chance: " + str(snapped(Global.crit_chance, 0.01)) + "%"
	crit_multi.text = "Crit Multi: " + str(Global.crit_multi) + "x"
	
	prestige.text = "Prestige: " + str(Global.prestige)
	

func _open_menu() -> void:
	
	_refresh_stats()
	stats_menu.visible = true
	pass

func _close_menu() -> void:
	
	stats_menu.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
	
