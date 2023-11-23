extends Control

# System functions
func _ready():
	# Save ranked data to dictionary
	writeDictionarySuccessMetrics();
	
	# Display last game metrics
	var playLength:int = ( global.RANKED.success + global.RANKED.fail )
	$Layout/CheerMessage.text = getCheerMessage(global.RANKED.success, global.RANKED.fail)
	$Layout/Points.text = str(global.RANKED.success) + "/" + str(playLength)
	
	# Reset global store
	global.RANKED = { 'success': 0, 'fail': 0, 'results': [] }

# Button functions
func _on_ok_pressed():
	global.init_next_scene("res://home.tscn")

# Cheer messages depending on success rate
func getCheerMessage(success:int, fail:int) -> String: 
	var success_rate: int = int(round(float((float(success) / float((success + fail))) * 100)))
	if success_rate == 100:
		$Layout/CheerEmoji.texture = EMOJI_FLAWLESS
		return 'Flawless!!!'
	elif success_rate >= 90:
		$Layout/CheerEmoji.texture = EMOJI_STAR
		return 'Great success!'
	elif success_rate >= 70:
		$Layout/CheerEmoji.texture = EMOJI_COOL
		return 'You are great!'
	elif success_rate >= 60:
		$Layout/CheerEmoji.texture = EMOJI_STRONG
		return 'Practice, and you will get even better!'
	elif success_rate < 60:
		$Layout/CheerEmoji.texture = EMOJI_SAD
		return 'Better luck next time...'
	else: 
		return '%default'
		
# Save values in dictionary
func writeDictionarySuccessMetrics():
	var _originalsList: Array = [] # List of originals to have a manifest
	
	for dictObjectIndex in global.RANKED.results.size():
		_originalsList.append(global.RANKED.results[dictObjectIndex]['original'])
		
	for dictRegister in global.DICTIONARY:
		if _originalsList.has(dictRegister['original']):
			for record in global.RANKED.results:
				if record['original'] == dictRegister['original']:
					dictRegister['success'] = record['success']
					dictRegister['fail'] = record['fail']
	
	# Adds to precommit and saves
	global.PRECOMMIT_DICTIONARY = { "dict": global.DICTIONARY }
	global.commit_json_file()
	global.PRECOMMIT_DICTIONARY = null

# Emoji preloads
var EMOJI_FLAWLESS = preload("res://imageres/emojis/100.png")
var EMOJI_COOL = preload("res://imageres/emojis/cool.png")
var EMOJI_STAR = preload("res://imageres/emojis/star_eyes.png")
var EMOJI_SAD = preload("res://imageres/emojis/sad_eyes.png")
var EMOJI_STRONG = preload("res://imageres/emojis/strong.png")
