extends Node3D

var GENERATED_WORDS = global.DICTIONARY # only test setup
var GAME_INDEX:int = 0
var TIMER_VALUE: float = 10.0
var IS_RANKED: bool = false

var TRANSLATION_DIRECTION: int # Random number (0, 1) 
var GLOBAL_DICTIONARY_COPY: Array = []
var RANKED_RESULTS_FOR_SAVING: Array = [] # Ranked results. Save at game finish.


# SYSTEM HOOKS

func _ready():
	# Create a copy from global dict
	for dictItem in global.DICTIONARY:
		GLOBAL_DICTIONARY_COPY.append(dictItem)
	
	# Load timer from settings
	var SETTINGS = global.load_json_file(global.SETTINGS_PATH)
	TIMER_VALUE = float(SETTINGS['timer'])
	
	# Ranked criteria
	var IS_FREEPLAY: bool = (global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.FREEPLAY)
	var IS_LEARN: bool = (global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.LEARN)
	
	# If ranking is needed
	if IS_FREEPLAY || IS_LEARN :
		IS_RANKED = false
	else:
		IS_RANKED = true
		
		match global.NEXT_SCENE_INSTRUCTIONS:
			global.SCENE_INSTRUCTIONS.TWENTYPLAY: generateDictionary(20)
			global.SCENE_INSTRUCTIONS.FIFTYPLAY: generateDictionary(50)
			global.SCENE_INSTRUCTIONS.HUNDREDPLAY: generateDictionary(100)
		
	# Bootstrap procedure
	start_card_procedure()

func _process(delta):
	# Handle timer bar
	var timePercentage = ($Timer.time_left / (TIMER_VALUE/100))
	$Camera3D/Control/ProgressBar.value = timePercentage
	
	# Enter submit has happened
	var timerIsValid: bool = (($Timer.time_left < TIMER_VALUE) && ($Timer.time_left != 0))
	var learnPlay: bool = (global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.LEARN)
	
	if Input.is_action_just_pressed("submit") && timerIsValid:
		wordWasSubmitted($Camera3D/Control/Input.text)
	
	elif Input.is_action_just_pressed("submit") && learnPlay:
		wordWasSubmitted($Camera3D/Control/Input.text)

# BUTTON HOOKS

# Exit game
func _on_back_pressed():
	if global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.FREEPLAY:
		global.init_next_scene("res://home.tscn")
	else:
		# TODO: prompt question if you want to quit or not
		global.init_next_scene("res://home.tscn")

# GAME CYCLES

# Path selector [first || !first]
func start_card_procedure():
	if GAME_INDEX == 0:
		flipUpFirstCard()
	else:
		flipUpNextCard()

# First path
func flipUpFirstCard():
	TRANSLATION_DIRECTION = randi_range(0, 1)
	$QuestionCard/QuestionCardLabel.text = GENERATED_WORDS[GAME_INDEX][getTransDirection('a')]
	$QuestionCard/FlipUp.play("flip_question_card")

# !First path
func flipUpNextCard():
	TRANSLATION_DIRECTION = randi_range(0, 1)
	
	# While game index is within dictionary constrainsts
	if GAME_INDEX <= (GENERATED_WORDS.size() - 1):
		$QuestionCard/QuestionCardLabel.text = GENERATED_WORDS[GAME_INDEX][getTransDirection('a')]
		$QuestionCard/FlipUp.queue("flip_question_card")
	else:
		match IS_RANKED:
			true:
				global.RANKED.results = RANKED_RESULTS_FOR_SAVING
				global.init_next_scene("res://src/scenes/evaluator.tscn")
			false:
				RANKED_RESULTS_FOR_SAVING = []
				global.init_next_scene("res://home.tscn")

# Answer evaluation
func wordWasSubmitted(answer: String = $Camera3D/Control/Input.text):
	$Camera3D/Control/Input.editable = false
	var transDirection = getTransDirection('b')
	var SUCCESS: bool = (answer == GENERATED_WORDS[GAME_INDEX][transDirection])
	
	# Evaluation
	if SUCCESS:
		$Feedback/Success.visible = true
		givePoints(GENERATED_WORDS[GAME_INDEX], 'success')
	
	else:
		$Feedback/Fail.visible = true
		$Feedback/Fail/Correction.text = GENERATED_WORDS[GAME_INDEX][transDirection]
		givePoints(GENERATED_WORDS[GAME_INDEX], 'fail')
	
	GAME_INDEX = GAME_INDEX + 1
	swipeOutThisCard()

# Swipe out card and finish evaluation -> init new swess
func swipeOutThisCard():
	$Timer.stop()
	$QuestionCard/FlipUp.queue("swipe_out")
	

# HELPER FNS

# Peripherial hooks
func _on_flip_up_animation_finished(anim_name):
	if anim_name == "flip_question_card":
		$Camera3D/Control/Input.editable = true
		
		if global.NEXT_SCENE_INSTRUCTIONS != global.SCENE_INSTRUCTIONS.LEARN:
			$Timer.wait_time = TIMER_VALUE
			$Timer.start()
			$Timer.timeout.connect(wordWasSubmitted)
		
	elif anim_name == "swipe_out":
		muteAllFeedbackSignals() # Reset success/fail
		flipUpNextCard()

# Get which side of text should be on the answer and the question side
func getTransDirection(side):
	match side:
		'a':
			if TRANSLATION_DIRECTION == 0 : return 'translation' 
			else: return 'original'
		'b':
			if TRANSLATION_DIRECTION == 0 : return 'original' 
			else: return 'translation'

# Ranking function
func givePoints(dictionaryEntry, result):
	# If ranking needed save points in dict
		if IS_RANKED:
			match result:
				'success':
					global.RANKED.success = global.RANKED.success + 1
					dictionaryEntry['success'] = int(dictionaryEntry['success']) + 1
				'fail':
					global.RANKED.fail = global.RANKED.fail + 1
					dictionaryEntry['fail'] = int(dictionaryEntry['fail']) + 1
			
			# Store result obj for saving
			RANKED_RESULTS_FOR_SAVING.append(dictionaryEntry)
			
		else: 
			pass

# Disable feedback signals
func muteAllFeedbackSignals():
	$Camera3D/Control/Input.text = ''
	$Feedback/Success.visible = false
	$Feedback/Fail.visible = false
	
# GENERATORS

# Generators entry
func generateDictionary(numberOfWords:int):
	# RULES:
	# - 50% of words are always low successrate words
	var lowSuccessRate: int = round(numberOfWords/2)
	# - 30% of words are not very known words (low show rate)
	var lowShowRate: int = round(numberOfWords/3)
	# - 20% (rest) are random other words
	var repetitoEstMaterStudiorum: int = (numberOfWords - (lowSuccessRate + lowShowRate))
	
	var _GENERATED: Array = getLowestSuccessRate(lowSuccessRate) + getLeastShown(lowShowRate) + getRandom(repetitoEstMaterStudiorum)

	GENERATED_WORDS = _GENERATED
	
	
# Returns a list of lowest success rate words
func getLowestSuccessRate(number: int):
	var wordList: Array = []
	
	while wordList.size() != number:
		var leastSuccessfulWord = filters.get_least_successrate(GLOBAL_DICTIONARY_COPY)
		GLOBAL_DICTIONARY_COPY.erase(leastSuccessfulWord)
		wordList.append(leastSuccessfulWord)
		
	return wordList
	
# Returns a list of least shown words
func getLeastShown(number: int):
	var wordList: Array = []
	
	while wordList.size() != number:
		var leastShowRateItem = filters.get_least_showrate(GLOBAL_DICTIONARY_COPY)
		GLOBAL_DICTIONARY_COPY.erase(leastShowRateItem)
		wordList.append(leastShowRateItem)
		
	return wordList

# Returns a list of random words
func getRandom(number: int):
	var wordList: Array = []
	while wordList.size() != number:
		var randIndex = randi_range(0, GLOBAL_DICTIONARY_COPY.size()-1)
		wordList.append(GLOBAL_DICTIONARY_COPY[randIndex])
		GLOBAL_DICTIONARY_COPY.erase(randIndex)

	return wordList
