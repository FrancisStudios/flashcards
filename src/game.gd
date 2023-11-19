extends Node3D

var GENERATED_WORDS = global.DICTIONARY # only test setup
var GAME_INDEX:int = 0
var TIMER_VALUE: float = 10.0
var IS_RANKED: bool = false

var TRANSLATION_DIRECTION: int # Random number (0, 1) 

var GLOBAL_DICTIONARY_COPY = global.DICTIONARY

# SYSTEM HOOKS

func _ready():
	# If ranking is needed
	if global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.FREEPLAY :
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
	if Input.is_action_just_pressed("submit") && timerIsValid:
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
		global.init_next_scene("res://home.tscn") # TODO: SOME SUCCESS SCREEN (eg 20/20 congrats!!!)

# Answer evaluation
func wordWasSubmitted(answer: String = $Camera3D/Control/Input.text):
	$Camera3D/Control/Input.editable = false
	var transDirection = getTransDirection('b')
	var SUCCESS: bool = (answer == GENERATED_WORDS[GAME_INDEX][transDirection])
	
	# Evaluation
	if SUCCESS:
		$Feedback/Success.visible = true
		givePoints()
	
	else:
		$Feedback/Fail.visible = true
		$Feedback/Fail/Correction.text = GENERATED_WORDS[GAME_INDEX][transDirection]
		givePoints()
	
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
func givePoints():
	# If ranking needed save points in dict
		if IS_RANKED:
			pass
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
	
	#var _GENERATED: Array = getLowestSuccessRate(lowSuccessRate) 
	#+ getLeastShown(lowShowRate) 
	#+ getRandom(repetitoEstMaterStudiorum)
	getRandom(numberOfWords)
	
# Returns a list of lowest success rate words
func getLowestSuccessRate(number: int):
	var successRates: Array = []
	var selectedWords: Array = []
	
	# Build an array of success rates
	for word in GLOBAL_DICTIONARY_COPY.size():
		var success = GLOBAL_DICTIONARY_COPY[word]['success']
		var fail = GLOBAL_DICTIONARY_COPY[word]['fail']
		var successRate: int
		
		# Eliminate division by zero
		if success != 0:
			successRate = int(round(float((float(success) / float((success + fail))) * 100)))
		else:
			successRate = 0
		
		# Build success rate obj
		successRates.append({
			'original': GLOBAL_DICTIONARY_COPY[word]['original'], 
			'successrate': successRate
		})
	
# Returns a list of least shown words
func getLeastShown(number: int):
	var wordList: Array = []
	var showRates: Array = []
	
	for word in GLOBAL_DICTIONARY_COPY.size():
		var showRate = GLOBAL_DICTIONARY_COPY[word]['success'] + GLOBAL_DICTIONARY_COPY[word]['fail']
		showRates.append(showRate)
	
	while wordList.size() != number:
		var smallest = showRates.min()
		print(smallest)
		for word in GLOBAL_DICTIONARY_COPY.size():
			if GLOBAL_DICTIONARY_COPY[word]['success'] + GLOBAL_DICTIONARY_COPY[word]['fail'] == smallest:
				wordList.append(word)
				GLOBAL_DICTIONARY_COPY.erase(word)

# Returns a list of random words
func getRandom(number: int):
	var wordList: Array = []
	while wordList.size() != number:
		var randIndex = randi_range(0, GLOBAL_DICTIONARY_COPY.size()-1)
		wordList.append(GLOBAL_DICTIONARY_COPY[randIndex])
		GLOBAL_DICTIONARY_COPY.erase(randIndex)

	return wordList
