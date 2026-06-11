extends Button

@export var menu: PanelContainer
@export var prestige_button: Button
@export var close_button: Button
@export var buff_text: Label
@export var req_text: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	menu.visible = false
	
	pressed.connect(_on_pressed)
	close_button.pressed.connect(_close_menu)
	prestige_button.pressed.connect(_prestige)
	
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	
	_open_menu()
	pass

func _close_menu() -> void:
	
	menu.visible = false

func _open_menu() -> void:
	
	menu.visible = true
	_update_prestige_ui()


func _update_prestige_ui() -> void:
	
	buff_text.text = "Prestiging gives buffs like 
	o +0.5x Click multi
	o +0.5x CPS multi"
	
	req_text.text = "Prestige Requirements
	o " + str((Global.prestige + 1) * 50) + " Levels"
	
func _prestige() -> void:
	
	if Global.level < (Global.prestige + 1) * 50:
		return
		
	Global.prestige += 1
	Global.level = 1
	Global.cookies = 0
	Global.cookies_ps = 0
	Global.cookies_pc = 1
	Global.xp = 0
	Global.exp = 100
	
	Global.click_multi = 1
	Global.seconds_multi = 1
	Global.xp_multi = 1
	
	Global.click_multi += (Global.prestige * 0.5) + (Global.completed_achievements * 0.05)
	Global.seconds_multi += (Global.prestige * 0.5) + (Global.completed_achievements * 0.05)
	
	Global.check_achievements()
	
	var data: Array = Global.upgrades
	
	for i in range(Global.upgrades.size()):
		Global.upgrades[i]["level"] = 1
		Global.upgrades[i]["cost"] = Global.upgrades[i]["base_cost"]
		
	_update_prestige_ui()
	Global.prestige_triggered.emit()
