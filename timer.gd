extends Timer
@export var cookieLabel: Label

func _ready() -> void:
	
	# Maakt de timer
	var timer = Timer.new()
	timer.wait_time = 1.0 # Herhaald elke 1 seconde
	timer.timeout.connect(_on_timeout)
	add_child(timer)
	timer.start()# starten van de timer
	pass 

# Functie van wat er gebeurd in de timer elke seconden
func _on_timeout() -> void:
	
	var final_cookies = (Global.cookies_ps * Global.seconds_multi)
	
	Global.cookies += final_cookies
	Global.total_cookies += final_cookies
	cookieLabel.text = "Cookies: 🍪 %s" % Global.format_num(floor(Global.cookies))
	
