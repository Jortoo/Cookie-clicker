extends Button

var achievements = Global.achievements
@export var close_button: Button
@export var grid_container: GridContainer
@export var template_item: VBoxContainer 
@export var menu: PanelContainer
@export var title: Label

# Norification
@export var notification_panel: PanelContainer
@export var notification_name_label: Label
@export var notification_desc: Label

func _ready() -> void:
	
	_reg_achievement("fingerworkout 1", "Finger Workout", "Click 100 times", "clicks", 100)
	_reg_achievement("fingerworkout 2", "Click Master", "Click 1k times", "clicks", 1000)
	_reg_achievement("fingerworkout 3", "Hand Workout", "Click 10k times", "clicks", 10000)
	_reg_achievement("fingerworkout 4", "Click King", "Click 100k times", "clicks", 100000)
	_reg_achievement("fingerworkout 5", "Clicker God", "Click 1M times", "clicks", 1000000)
	
	_reg_achievement("baker", "Baker", "Bake 10k Lifetime cookies", "cookies", 10000)
	_reg_achievement("baker", "Ultimate Baker", "Bake 250k Lifetime cookies", "cookies", 250000)
	_reg_achievement("baker", "Master Baker", "Bake 1,5M Lifetime cookies", "cookies", 1500000)
	_reg_achievement("baker", "Baker King", "Bake 10M Lifetime cookies", "cookies", 10000000)
	_reg_achievement("baker", "Baker God", "Bake 50M Lifetime cookies", "cookies", 50000000)

	_reg_achievement("leveler", "Leveler", "Reach level 10", "level", 10)
	_reg_achievement("leveler", "Ultimate Leveler", "Reach level 50", "level", 50)
	_reg_achievement("leveler", "Crazy Leveler", "Reach level 100", "level", 100)
	_reg_achievement("leveler", "Master Leveler", "Reach level 250", "level", 250)
	_reg_achievement("leveler", "Leveler King", "Reach level 500", "level", 500)
	_reg_achievement("leveler", "Leveler God", "Reach level 1k", "level", 1000)

	_reg_achievement("prestiger", "Prestiger", "Reach Prestige 1", "prestige", 1)
	_reg_achievement("prestiger", "Ultimate Prestiger", "Reach Prestige 3", "prestige", 3)
	_reg_achievement("prestiger", "Crazy Prestige", "Reach Prestige 5", "prestige", 5)
	_reg_achievement("prestiger", "Prestige King", "Reach Prestige 10", "prestige", 10)

	_reg_achievement("upgrader", "Upgrader", "Upgrade 20 upgrades", "upgrade", 20)
	_reg_achievement("upgrader", "Upgrader", "Upgrade 100 upgrades", "upgrade", 100)
	_reg_achievement("upgrader", "Upgrader", "Upgrade 250 upgrades", "upgrade", 250)
	_reg_achievement("upgrader", "Upgrader", "Upgrade 1k upgrades", "upgrade", 1000)
	_reg_achievement("upgrader", "Upgrader", "Upgrade 2,5k upgrades", "upgrade", 2500)
	_reg_achievement("upgrader", "Upgrader", "Upgrade 10k upgrades", "upgrade", 10000)
	
	menu.visible = false
	notification_panel.visible = false
	template_item.visible = false 

	close_button.pressed.connect(func(): menu.visible = false)
	
	pressed.connect(open_menu)
	Global.achievement_unlocked.connect(_show_notification)
	_build_achievement_list()
	
func open_menu() -> void:
	menu.visible = true
	_build_achievement_list()
	
func _build_achievement_list() -> void:
	
	var i: int = 0
	
	for child in grid_container.get_children():
		if child != template_item:
			child.queue_free()
			
	for ach in Global.achievements:
		
		i += 1 
		
		var new_item = template_item.duplicate()
		new_item.visible = true
		grid_container.add_child(new_item)
		
		var title_label = new_item.get_node("Button/Name")
		var desc_label = new_item.get_node("Button/Desc")
		var req_label = new_item.get_node("Button/Req")
		var bar = new_item.get_node("Button/ProgressBar")
		
		title_label.text = ach["name"]
		desc_label.text = ach["desc"]
		req_label.text = "%s/%s" % [Global.format_num(_return_data(ach["type"])), Global.format_num(ach["req"])]
		if ach["unlocked"]:
			req_label.add_theme_color_override("font_color", Color.GOLD)
			req_label.text = "Completed"
		else:
			req_label.add_theme_color_override("font_color", Color.GRAY)
			desc_label.add_theme_color_override("font_color", Color.DARK_GRAY)
		
		bar.min_value = 0
		bar.max_value = ach["req"]
		bar.value = _return_data(ach["type"])

	
		
		Global.total_achievements = i
		title.text = "Achievements (" + str(Global.completed_achievements) + "/" + str(Global.total_achievements) + ")"
		
func _reg_achievement(id: String, name: String, desc: String, type: String, req: int) -> void:
	var achievement_data = {
		"id": id,
		"name": name,
		"desc": desc,
		"type": type,
		"req": req,
		"unlocked": false
	}
	achievements.append(achievement_data)

func _return_data(type: String) -> int:
	
	var data = 0
	
	match type:
		
		"clicks": data = Global.clicks
		"cookies": data = Global.total_cookies
		"prestige": data = Global.prestige
		"level": data = Global.level
		"upgrade": data = Global.total_upgrades
		
	
	return data

func _check_achievements_progress() -> void:
	
	for ach in Global.achievements:
		if ach["unlocked"]:
			continue
			
		var current_progress = _return_data(ach["type"])
		
		if current_progress >= ach["req"]:
			ach["unlocked"] = true
			Global.achievement_unlocked.emit(ach["name"])

func _show_notification(ach_name: String) -> void:
	
	if notification_panel and notification_name_label:
		notification_name_label.text = "Achievement Unlocked!"
		notification_desc.text = ach_name + " (+0.05x)"
		notification_panel.visible = true

		await get_tree().create_timer(3.0).timeout
		notification_panel.visible = false

		_build_achievement_list()
