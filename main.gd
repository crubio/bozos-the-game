extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$GameMusic.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.game_over()
	
func new_game():
	$GameMusic.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score) # using the methods of the HUD which controls game UI stuff
	$HUD.show_message("get ready!")
	get_tree().call_group("mobs", "queue_free")
	
# These functions are invoked when a signal is issues - see the green arrowbox next to the func
# Mob timer should spawn mobs on timeout.
func _on_mob_timer_timeout() -> void:
	# create a new intance of mob_scene. 
	var mob = mob_scene.instantiate()
	
	# randomly pick where the mob spawns
	var mob_spawn_location =$MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
		# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

# add to score on each timeout, 1sec
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
