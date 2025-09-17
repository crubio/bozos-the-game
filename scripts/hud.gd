extends CanvasLayer

# Sends a signal to Main that start button is pressed
signal start_game

func update_score(score):
	$ScoreLabel.text = str(score)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func game_over():
	show_message("game over")
	await $MessageTimer.timeout #Message timer start when show_message invoked, wait until done
	
	$Message.text = "try again..."
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide() # hide when game is moving
	start_game.emit()
	$Message.hide()


func _on_message_timer_timeout() -> void:
	$Message.hide()
