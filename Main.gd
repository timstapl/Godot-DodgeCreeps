extends Node2D

export (PackedScene) var Mob
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# stop timers when game is over (called by player being hit)
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

# spins the game back up
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

# once the start timer has completed, start the game in earnest
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

# Everytime the score timer completes, increment the player's score
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

# Spawn a new mob each time this timer completes
func _on_MobTimer_timeout():
	# Choose a random location on the path
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob, and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to the random location
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the mobs velocity
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
