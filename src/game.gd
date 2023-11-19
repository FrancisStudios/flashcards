extends Node3D

var GENERATED_WORDS = global.DICTIONARY # only test setup
var GAME_INDEX:int = 0
var TIMER_VALUE: float = 10.0
var IS_RANKED: bool = false

var TRANSLATION_DIRECTION: int # Random number (0, 1) 

# SYSTEM HOOKS

func _ready():
	# If ranking is needed
	if global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.FREEPLAY :
		IS_RANKED = false
	else:
		IS_RANKED = true
		
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
