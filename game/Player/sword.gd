extends Area2D
@onready var anim = $WeaponAnim
@export var damage := 1



func _physics_process(_delta):
	look_at(get_global_mouse_position())#points sword towards mouse


func sword_attack():#attack method referenced in parent script
	anim.play("swordSwing")
	
func attack():
		sword_attack()



func _on_body_entered(body: Node) -> void:#detects when it collides with and enemy and deals damage
	if body.has_method("get_hit"):
		body.get_hit(damage)
