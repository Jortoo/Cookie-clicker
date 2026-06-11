# shop.gd - Maak een nieuw script voor je shop
extends Control

@onready var upgrade1_button = $UpgradeButton
@onready var upgrade1_cost_label = $UpgradeButton/CostLabel

@onready var cookies_button = $"../Control/CookieCount"
@onready var cookies_ps_button = $"../Control/CookiePS"

@onready var shopButton = $UpgradeButton

var upgrade1_cost = 10
var upgrade1_cps = 1
var level = 1

func _ready():
	upgrade1_button.pressed.connect(_on_upgrade1_pressed)
	update_ui()

func _process(delta):
	upgrade1_button.disabled = Global.cookies < upgrade1_cost
	update_ui()

func _on_upgrade1_pressed():
	if Global.cookies >= upgrade1_cost:
		Global.cookies -= upgrade1_cost
		Global.cookies_ps += upgrade1_cps
		upgrade1_cost = int(upgrade1_cost * 1.5)
		level += 1
		update_ui()

func update_ui():
	upgrade1_cost_label.text = str(upgrade1_cost) + " cookies"
	cookies_button.text = "Cookies: " + str(Global.cookies)
	cookies_ps_button.text = "Cookies p/s: " + str(Global.cookies_ps)
	shopButton.text = "Cookie Upgrade Lv. " + str(level)
	
