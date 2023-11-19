extends Node3D

var GENERATED_WORDS = global.DICTIONARY # only test setup
var GAME_INDEX:int = 0
var TIMER_VALUE: float = 20.0

func _ready():
	start_card_procedure()
	

func _process(delta):
	
	var timePercentage = ($Timer.time_left / (TIMER_VALUE/100))
	$Camera3D/Control/ProgressBar.value = timePercentage
	
	if Input.is_action_just_pressed("submit"):
		wordWasSubmitted($Camera3D/Control/Input.text)

func _on_back_pressed():
	if global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.FREEPLAY:
		global.init_next_scene("res://home.tscn")

func start_card_procedure():
	if GAME_INDEX == 0:
		flipUpFirstCard()
	else:
		flipUpNextCard()
		
func flipUpFirstCard():
	$QuestionCard/QuestionCardLabel.text = GENERATED_WORDS[GAME_INDEX]['original']
	$QuestionCard/FlipUp.play("flip_question_card")
	
func flipUpNextCard():
	if GAME_INDEX <= GENERATED_WORDS.size():
		$QuestionCard/FlipUp.play("flip_question_card")
		$QuestionCard/FlipUp.queue("swipe_out")
		$QuestionCard/FlipUp.queue("flip_question_card")
		# $QuestionCard/FlipUp.animation_finished.connect(swipeOutThisCard)
		
func wordWasSubmitted(answer: String):
	
	if answer == GENERATED_WORDS[GAME_INDEX]['translation']:
		$Feedback/Success.visible = true
	else:
		$Feedback/Fail.visible = true
		$Feedback/Fail/Correction.text = GENERATED_WORDS[GAME_INDEX]['translation']
		
func swipeOutThisCard():
	print('swipe out can happen')
	print($Timer.time_left)
	# $Timer.stop()

func _on_flip_up_animation_finished(anim_name):
	if anim_name == "flip_question_card":
		$Timer.wait_time = TIMER_VALUE
		$Timer.start()
		$Timer.timeout.connect(swipeOutThisCard)
