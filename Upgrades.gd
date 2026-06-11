extends VBoxContainer

var upgrades = Global.upgrades

@onready var template_item = $UpgradeItem

@export var cps_counter: Label
@export var cookies_counter: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Registreren van alle upgrades
	# Id, Naam, StartPrijs, UpgradeType, upgrade per level, Description, max level (0 = infinite)
	register_upgrade("autoclicker", "Auto Clicker", 15, "cps", 1, "Adds +1 CPS", 0)
	register_upgrade("chef", "Chef", 100, "cpc", 1.0, "Adds +1 CPC", 0)
	register_upgrade("grandmas", "Grandma's", 1100, "cps", 8.0, "Adds +8 CPS", 25)
	
	# Procentuele multipliers (Mid-game)
	register_upgrade("luckytree", "Lucky Tree", 12000, "cps_multi", 0.15, "Adds +0.15x CPS multi", 10)
	register_upgrade("goldenglove", "Golden Glove", 15000, "cpc_multi", 0.15, "Adds +0.15x CPC multi", 10)
	
	# Crits en zwaardere upgrades (End-game)
	register_upgrade("crittap", "Crit Tap", 85000, "crit_chance", 2.0, "Adds +2.0% Crit Chance", 15)
	register_upgrade("critmulti", "Crit Multi", 250000, "crit_multi", 0.5, "Adds +0.5x Crit Multi", 10)
	register_upgrade("diamondglove", "Diamond Glove", 1000000, "cpc_multi", 0.4, "Adds +0.4x CPC multi", 5)
	register_upgrade("luckiertree", "Luckier Tree", 5000000, "cps_multi", 0.4, "Adds +0.4x CPS multi", 5)
	
	register_upgrade("wizard", "Wizard", 250000, "xp_multi", 0.5, "Adds 0.5x XP Multi", 5)
	register_upgrade("wizarduncle", "Wizard's Uncle", 2500000, "xp_multi", 1, "Adds 1x XP Multi", 5)
	
	Global.prestige_triggered.connect(_on_prestige_reset)
	
	# Standaard de shop hiden
	template_item.visible = false
	
	_build_shop_ui()
	pass 

# Functie om een nieuwe upgrade button te maken
func _create_update_ui_button(data:Dictionary) -> void:

	var new_item = template_item.duplicate() # De preset button kopieeren
	new_item.visible = true # Maak het menuutje visible
	add_child(new_item) # Voeg een child toe aan de button
	
	# De labels zetten 
	var button = new_item.get_node("UpgradeButton")
	var cost_label = button.get_node("CostLabel")
	var title_label = button.get_node("TitleLabel")
	var desc_label = button.get_node("DescLabel")
	
	# Max level checken
	var max_level = Global.format_num(data["max_level"])
	
	if max_level == str(0):# als max level 0 is naar infinity zetten
		
		max_level = "∞"
	
	# De labels zetten
	cost_label.text = Global.format_num(data["cost"]) + "🍪 Cookies"
	title_label.text = data["name"] + " (Lv. 1 / %s" % max_level + ")"
	desc_label.text = data["desc"]
	
	# de functionaliteit aan de knop connecten
	button.pressed.connect(func(): _on_upgrade_click(data, button))

# Update van de knop elke upgrade
func _update_upgrade_ui(data:Dictionary, button:Button) -> void:

	# Max level
	var max_level = data["max_level"]
	
	# De knop hiden als je die upgrade max level hebt
	if max_level != 0 and data["level"] >= max_level:
		var upgrade_item_node = button.get_parent()
		upgrade_item_node.queue_free() # verwijderen uit het menu 
		return
	
	# zet de cost van de upgrade, naar "Max level" zetten als hij max level is
	if max_level != 0 and data["level"] >= max_level: 
		button.get_node("CostLabel").text = "Max Level"
	else:
		button.get_node("CostLabel").text = Global.format_num(data["cost"]) + "🍪 Cookies"
	
	# Zet de title label
	if max_level == 0:
		max_level = "∞"
		
	button.get_node("TitleLabel").text = data["name"] + " (Lv. " + str(data["level"]) + " / %s" % max_level + ")"
	
	#het updaten van de counters
	cps_counter.text = "Cookies p/s: " + str(Global.cookies_ps * Global.seconds_multi)
	cookies_counter.text = "Cookies: 🍪 %s" % Global.format_num(floor(Global.cookies))

# De functie van het upgraden
func _on_upgrade_click(data: Dictionary, button: Button) -> void:
	var max_level = data["max_level"]
		
	# Stoppen als hij max level is
	if max_level != 0 and data["level"] >= max_level:
		return
		
	# Stoppen als je niet genoeg koekjes hebt
	var cookies = Global.cookies
	var cost = data["cost"]
	if cookies < cost:
		return

	Global.cookies -= cost # De kosten van de koekjes aftrekken
	
	data["level"] += 1 # upgrade level omhoog
	Global.total_upgrades += 1

	var level = data["level"]
	var base_cost = data["cost"]
	
	# Functionaliteit van elke specifieke upgrade type
	match data["type"]:
		"cpc":
			Global.cookies_pc += data["bonus"]
			data["cost"] = base_cost * pow(1.15, level - 1)
		"cps":
			Global.cookies_ps += data["bonus"]
			data["cost"] = base_cost * pow(1.15, level - 1)
		"cps_multi":
			Global.seconds_multi += data["bonus"]
			data["cost"] = base_cost * pow(1.3, level - 1) # Iets duurder omdat het procentueel is
		"cpc_multi":
			Global.click_multi += data["bonus"]
			data["cost"] = base_cost * pow(1.3, level - 1)
		"crit_chance":
			Global.crit_chance += data["bonus"]
			data["cost"] = base_cost * pow(1.4, level - 1)
		"crit_multi":
			Global.crit_multi += data["bonus"]
			data["cost"] = base_cost * pow(1.4, level - 1)
		"xp_multi":
			Global.crit_multi += data["bonus"]
			data["cost"] = base_cost * pow(1.4, level - 1)
			
	data["cost"] = floor(data["cost"]) # De prijs afronden (Ziet er netter uit)
	
	_update_upgrade_ui(data, button) # Updaten van de ui

# Functie om een upgrade te registreren
func register_upgrade(id: String, name: String, cost: int, type: String, bonus: float, desc: String, max_level: int) -> void:
	var upgrade_data = {
			"id": id,
			"name": name,
			"cost": cost,
			"type": type,
			"bonus": bonus,
			"desc": desc,
			"level": 1,
			"max_level": max_level,
			"base_cost": cost
	}
	upgrades.append(upgrade_data)

func _build_shop_ui() -> void:
	
	for upgrade_data in upgrades:
		_create_update_ui_button(upgrade_data)

func _on_prestige_reset() -> void:

	for child in get_children():
		if child != template_item:
			child.queue_free()

	_build_shop_ui()

	cps_counter.text = "Cookies p/s: " + str(Global.cookies_ps * Global.seconds_multi)
	cookies_counter.text = "Cookies: 🍪 " + Global.format_num(floor(Global.cookies))
