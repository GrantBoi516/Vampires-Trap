extends CharacterBody2D


@export var skeleHP = 2
@export var speed = 1
var player_position
var target_position
@onready var player = get_parent().get_node("CharacterBody2D")
@onready var attack = $SkeleAttack
@onready var coin = load("res://Items/coin.tscn")
@onready var heart = load("res://Items/heart.tscn")
@onready var fireball = load("res://Enemies/wizardskeleton/skele_attack.tscn")
var random = RandomNumberGenerator.new()
var tmp = 1

func _physics_process(delta):
	movement()
	
func get_hit(damage):#damages and deletes skeleton
	skeleHP -= damage
	print("enemy was hit, HP:" + str(skeleHP))
	if skeleHP <= 0:
		coin_drop()
		heart_drop()
		queue_free()
		knockback()

func movement():
	if position.distance_to(player.position) < 100:#makes skele stop so it can shoot fireballs
		animation(target_position)
		shoot_fireball()
	elif position.distance_to(player.position) < 200:#gives skeleton a following distance
		follow()
	animation(target_position)

func knockback():
	player_position = player.position
	target_position = -(player_position - position).normalized() * 80
	move_and_collide(target_position)


func follow():#makes skeleton follow the player
	if player.HP <= 0:
		target_position = Vector2.ZERO
	else:
		player_position = player.position
		target_position = (player_position - position).normalized()
		move_and_collide(target_position * speed)
		print(position.distance_to(player_position))
	return target_position
	return player_position
func shoot_fireball():
	var instancedFireball = fireball.instantiate()
	get_parent().add_child(instancedFireball)
	instancedFireball.position = position

func animation(tp: Vector2):#adjusts animation tree based on movements
	if position.distance_to(player.position) <= 100:
		$SkeleAnim/AnimationTree.get("parameters/playback").travel("Idle")
		return
	if position.distance_to(player.position) > 200:
		$SkeleAnim/AnimationTree.get("parameters/playback").travel("Idle")
		return
	else:
		if tp == Vector2.ZERO:
			$SkeleAnim/AnimationTree.get("parameters/playback").travel("Idle")
		else:
			$SkeleAnim/AnimationTree.get("parameters/playback").travel("Walk")
			$SkeleAnim/AnimationTree.set("parameters/Idle/blend_position", tp)
			$SkeleAnim/AnimationTree.set("parameters/Walk/blend_position", tp)
	if position.distance_to(player.position) < 30:
		$SkeleAnim/AnimationTree.get("parameters/playback").travel("Idle")
		return


func coin_drop():
	while tmp <= 1:
		random.randomize()
		var x = random.randi_range(-10, 10)
		var y = random.randi_range(-10, 10)
		var instancedCoin = coin.instantiate()
		get_parent().add_child(instancedCoin)
		instancedCoin.position.y = position.y + y
		instancedCoin.position.x = position.x + x
		tmp += 1
	tmp = 1




func heart_drop():
	while tmp <= 1:
		random.randomize()
		var x = random.randi_range(-10, 10)
		var y = random.randi_range(-10, 10)
		var instancedHeart =heart.instantiate()
		get_parent().add_child(instancedHeart)
		instancedHeart.position.y = position.y + y
		instancedHeart.position.x = position.x + x
		tmp += 1
	tmp = 1
