extends Node

signal game_prestiged

var total_achievements: int = 0
var completed_achievements: int = 0

var cookies: float = 0.0
var total_cookies: float = 0.0
var clicks: int = 0.0
var cookies_ps: float = 1.0
var cookies_pc: float = 1.0

var total_upgrades: int = 0

var level: int = 1
var xp: float = 0.0
var exp: float = 500
var prestige: int = 0

var click_multi: float = 1.0
var seconds_multi: float = 1.0
var crit_chance: float = 0.0
var crit_multi: float = 2.0
var xp_multi: float = 1.0

var upgrades: Array = []
var achievements: Array = []

# Genereerd een random getal
func random_chance(chance: float) -> bool:
	var random_getal = randf_range(0.0, 100.0)
	
	if random_getal <= chance:
		return true
		
	return false

# Format de nummers naar 1,000 ipv 1000	
func format_num(n: float) -> String:
	
	if abs(n) < 1000: return str(int(floor(n)))
	
	var letters = [
		"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", 
		"UDc", "DDc", "TDc", "QaDc", "QiDc", "SxDc", "SpDc", "OcDc", "NoDc", "Vg",
		"UVg", "DVg", "TVg", "QaVg", "QiVg", "SxVg", "SpVg", "OcVg", "NoVg", "Tg",
		"UTg", "DTg", "TTg", "QaTg", "QiTg", "SxTg", "SpTg", "OcTg", "NoTg", "Qd",
		"Qn", "Sx", "Sp", "O", "N", "V", "C"
	]
	
	var i = min(floor(log(abs(n)) / log(1000)), letters.size() - 1)
	var letter = letters[i]
	
	var res = "%0.2f" % (n / pow(1000, i)) + letter
	
	if res.contains(".00" + letter):
		res = res.replacen(".00" + letter, letter)
	elif res.contains(".0" + letter):
		res = res.replacen(".0" + letter, letter)
	elif res.ends_with("0" + letter) and "." in res:
		res = res.left(res.length() - (1 + letter.length())) + letter
		
	return res
	
signal achievement_unlocked(achievement_name: String)

func check_achievements() -> void:
	for ach in achievements:
		if ach["unlocked"] == true:
			continue
			
		var condition_met = false
		
		match ach["type"]:
			"clicks":
				if clicks >= ach["req"]:
					condition_met = true
			"cookies":
				if total_cookies >= ach["req"]:
					condition_met = true
			"prestige":
				if prestige >= ach["req"]:
					condition_met = true
			"level":
				if level >= ach["req"]:
					condition_met = true
			"upgrades":
				if total_upgrades >= ach["req"]:
					condition_met = true
										
		if condition_met:
			ach["unlocked"] = true
			achievement_unlocked.emit(ach["name"])
			Global.completed_achievements += 1
			Global.click_multi += 0.05
			Global.seconds_multi += 0.05
			
signal prestige_triggered			
	
