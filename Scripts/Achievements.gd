extends PanelContainer
@export var close_button: Button
@export var vbox_container: VBoxContainer
@export var template_item: HBoxContainer 

var achievements = Global.achievements

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_reg_achievement("fingerworkout", "Finger Workout", "Click 100 times", "clicks", 100)
	visible = false
	close_button.pressed.connect(func(): visible = false)
	template_item.visible = false
	_build_achievement_list()
	
	pass # Replace with function body.
	
func open_menu() -> void:
	visible = true
	_build_achievement_list()

func _build_achievement_list() -> void:
	
	var i = 0
	# Maak de lijst eerst leeg (behalve de template)
	for child in vbox_container.get_children():
		if child != template_item:
			child.queue_free()
			
	# Loop door alle achievements in Global
	for ach in Global.achievements:
		
		i += 1
		
		var new_item = template_item.duplicate()
		new_item.visible = true
		vbox_container.add_child(new_item)
		
		var title_label = new_item.get_node("Name")
		var desc_label = new_item.get_node("Desc")
		
		title_label.text = ach["name"]
		desc_label.text = ach["desc"]
		
		# Pas de kleur of tekst aan op basis van unlocked status
		if ach["unlocked"]:
			title_label.add_theme_color_override("font_color", Color.GOLD)
			title_label.text += " (Unlocked! 🎉)"
		else:
			title_label.add_theme_color_override("font_color", Color.GRAY)
			desc_label.add_theme_color_override("font_color", Color.DARK_GRAY)

		Global.total_achievements == i
		
func _check_achievements() -> void:
	
	for ach in achievements:
		
		if ach["unlocked"] == true:
			return
			
		var condition_met = false
		
		match ach["type"]:
			
			"clicks":
				
				if Global.clicks >= ach["clicks"]:
					condition_met = true
					
		if condition_met == false:
			return
		
		Global.completed_achievements += 1
		ach["unlocked"] = true

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
