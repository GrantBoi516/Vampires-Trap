extends CharacterBody2D


@export var speed = 3.0
@export var HP = 4
@export var max_HP = 4
@export var coins = 0
@onready var sword = $sword
@onready var axe = $axe
@export var weapon_val = "sword"
@onready var weapon = sword


var instancedAxe = load("res://Player/axe.tscn")
func _physics_process(_delta):
	get_parent().get_node("HUD/CC/Label").text = "coins:" + str(coins)
	movement(velocity)#calls movement
	
	
func _processAxe(delta):
	while weapon_val == "axe":
		sword.get_node("hitbox").disabled = true
		sword.get_node("Sprite2D").hide
		axe.get_node("hitbox").disabled = false
		weapon = axe
func _processSword(delta):
	while weapon_val == "axe":
		axe.get_node("hitbox").disabled = true
		axe.get_node("Sprite2D").hide
		sword.get_node("hitbox").disabled = false


func movement(v):#player inputs for movement
	if Input.is_action_pressed("god"):
		HP = 100
	if Input.is_action_pressed("d"):
		v.x += 1
	if Input.is_action_pressed("a"):
		v.x -= 1
	if Input.is_action_pressed("s"):
		v.y += 1
	if Input.is_action_pressed("w"):
		v.y -= 1
	v = v.normalized()
	if v == Vector2.ZERO:
		$PlayerAnim/AnimTree.get("parameters/playback").travel("Idle")
	else:
		$PlayerAnim/AnimTree.get("parameters/playback").travel("Walk")
		$PlayerAnim/AnimTree.set("parameters/Idle/blend_position", v)
		$PlayerAnim/AnimTree.set("parameters/Walk/blend_position", v)
	move_and_collide(v * speed)
	return v

func axe_change():
	weapon = axe
	weapon_val = "axe"
func sword_change():
	weapon = sword
	weapon_val = "sword"

func player_hit(damage):#handles getting hit
	HP -= damage
	print("player was hit, HP:" + str(HP))




func die():
	#overlay death screen
	var deathscreen = load("res://Menus/death_menu.tscn").instantiate()
	get_parent().add_child(deathscreen)
	$Sprite2D.hide()
	get_node("hitbox").disabled = true
	weapon.get_node("Sprite2D").hide()
	weapon.get_node("hitbox").disabled = true
	




func get_coin():#adds a coin
	coins += 1
	print("got coin")


func get_heart():#adds a heart
	HP += 1
	print("got heart")



func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("click"):#attack action
		weapon.attack()
