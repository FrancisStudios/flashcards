extends Control

var SELECTED_ITEM = null

func _ready():
	var itemList = get_node('NinePatchRect/ItemList')
	
	for itemIndex in global.DICTIONARY.size():
		var itemText = global.DICTIONARY[itemIndex]['original'] + ' = ' + global.DICTIONARY[itemIndex]['translation']
		var stars = get_star_icons(global.DICTIONARY[itemIndex]['success'], global.DICTIONARY[itemIndex]['fail'])
		itemList.add_item(itemText, stars, true)

func _on_back_pressed():
	SELECTED_ITEM = null
	global.commit_json_file() # If no modifs commit obj will be null
	global.init_next_scene('res://home.tscn')
	
func get_star_icons(success: int, fail: int):
	var nStars = global.get_stars(success, fail)
	match nStars:
		0: return global.STAR_00
		0.5: return global.STAR_05
		1: return global.STAR_10
		1.5: return global.STAR_15
		2: return global.STAR_20
		2.5: return global.STAR_25
		3: return global.STAR_30

# BUTTON HANDLERS
func _on_add_pressed():
	SELECTED_ITEM = null
	global.write_json_file($NinePatchRect/TopBar/Original.text, $NinePatchRect/TopBar/Translation.text)
	var newItem = $NinePatchRect/TopBar/Original.text + ' = ' + $NinePatchRect/TopBar/Translation.text
	get_node('NinePatchRect/ItemList').add_item(newItem, global.STAR_00, true)
	$NinePatchRect/TopBar/Original.text = ''
	$NinePatchRect/TopBar/Translation.text = '' 
	
func _on_remove_pressed():
	if SELECTED_ITEM != null:
		global.remove_from_json_file(SELECTED_ITEM)
		get_node('NinePatchRect/ItemList').remove_item(SELECTED_ITEM)
		
func _on_item_list_item_selected(index):
	SELECTED_ITEM = index;
