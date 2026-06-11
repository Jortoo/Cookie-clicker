extends TextureButton
@export var label: Label
@export var bar: ProgressBar
@export var bar_title: Label
var original_scale = Vector2.ZERO
var tween: Tween

func _ready() -> void:
	
	pivot_offset = size / 2
	position = get_viewport_rect().size / 2 - size / 2
	original_scale = scale
	pressed.connect(func(): _on_pressed())
	_update_bar()

func _on_pressed() -> void:
	var base_cookies = ((Global.cookies_pc + (Global.level - 1)) * (Global.click_multi))
	
	var final_cookies = _click_rewards(base_cookies)
	
	_update_ui()
	_create_cookie_tween()
	
	var color = Color.BLACK
	var txt = "+ %s" % Global.format_num(final_cookies)
	if final_cookies > base_cookies:
		txt = "CRIT! + %s" % Global.format_num(final_cookies)
		color = Color.ORANGE
	
	Global.check_achievements()
	show_popup_text(txt, color)

func _create_cookie_tween() -> void:
	
	if tween:
		tween.kill()
	
	# Maakt de tween 
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", original_scale * 1.15, 0.05)
	tween.tween_property(self, "scale", original_scale, 0.05)

# Handled al de click rewards zodat mijn main functie niet een spagethi wordt
func _click_rewards(cookies: float) -> float:
	# Handeld met de crit
	if _crit_reward():
		cookies = (cookies * Global.crit_multi)
	
	# Geeft alle rewards
	Global.cookies += cookies
	Global.total_cookies += cookies
	Global.clicks += 1
	_add_xp(cookies)
	
	return cookies

func _crit_reward() -> bool:
	var crit: bool = Global.random_chance(Global.crit_chance)
	return crit

# Update alle ui dat geupdate moet worden
func _update_ui() -> void:
	
	_update_bar()
	label.text = "Cookies: 🍪 %s" % Global.format_num(floor(Global.cookies)) # Update de counter

# Maakt de popup achter het koekje gemaakt door ai, want ik kwam er niet uit
func show_popup_text(text: String, color: Color):
	var container = Control.new()
	
	var spawn_pos = global_position + ((size * scale) / 2)
	
	var random_offset = Vector2(
		randf_range(-60, 60), 
		randf_range(-60, 60) 
	)
	container.position = spawn_pos + random_offset
	container.z_index = 1 
	get_parent().add_child(container)
	
	var cookie_icon = Sprite2D.new()
	cookie_icon.texture = load("res://koekje (2).png")
	cookie_icon.scale = Vector2(0.03, 0.03)
	cookie_icon.position = Vector2(0, 0)
	container.add_child(cookie_icon)
	
	var popup = Label.new()
	popup.text = text
	popup.add_theme_font_size_override("font_size", 32)
	popup.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup.add_theme_constant_override("outline_size", 6)
	popup.add_theme_color_override("font_outline_color", color)
	popup.position = Vector2(-50, -20)
	popup.size = Vector2(100, 40)
	container.add_child(popup)
	
	var popup_tween = create_tween()
	popup_tween.set_ease(Tween.EASE_OUT)
	popup_tween.set_trans(Tween.TRANS_QUAD)
	popup_tween.tween_property(container, "position:y", container.position.y - 60, 0.8)
	popup_tween.parallel().tween_property(container, "modulate:a", 0.0, 0.8)
	popup_tween.tween_callback(container.queue_free)

# Update de xp bar	
func _update_bar() -> void:
	
	var xp_needed = Global.exp # Xp nodig voor het volgende level
	
	# Hier zet ik de values van dde progress bar
	bar.min_value = 0
	bar.max_value = xp_needed
	bar.value = Global.xp
	
	bar_title.text = "Level: " + str(Global.level) + " (xp: %s" % Global.format_num(Global.xp)  + "/%s" % Global.format_num(Global.exp)  + ") (+1 per click)"

	pass

# Voegt de xp toe en checkt gelijk of je levelup kan
func _add_xp(amount: int) -> void:
	
	amount += (amount * Global.xp_multi)
	Global.xp += amount
	_check_levelup()
	

func _check_levelup() -> void:
	
	# Check om te zien of je meer xp heb dan dat je nodig hebt
	if Global.xp < Global.exp:
		return
	
	while (Global.xp >= Global.exp): 
		# Berekent wat je over hebt kwa xp zodat je xp terug krijgt als je over de requirement zit
		var xp_needed = Global.exp
		
		# level omhoog
		Global.level += 1
		Global.exp += (Global.exp * 0.05)
		Global.xp -= xp_needed
		
		# Voeg koekjes toe bij een level up
		var levelup_cookies: float = (100 * Global.level) * (Global.click_multi)
		Global.cookies += levelup_cookies
		Global.total_cookies += levelup_cookies
		show_popup_text("Level Up! + %s" % Global.format_num(levelup_cookies), Color.AQUA)
		
		# Checked voor de level achievements
		Global.check_achievements()
		# bar title update
		bar_title.text = "Level: " + str(Global.level) + " (xp: %s" % Global.format_num(Global.xp)  + "/%s" % Global.format_num(Global.exp)  + ") (+1 per click)"
