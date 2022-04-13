extends CharacterBody3D

var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
var Axys = Vector2(0, 0)
var RotacaoMouse = Vector2(0, 0)
var Sensibilidade = 0.2
var Velocidade = 5.0
var VelocidadePulo = 6.0
var VelocidadeGravidade = 0.0
var Animator = null

func _ready():
	Animator = $AnimationTree["parameters/playback"]
	pass

func _physics_process(delta):
	RotacaoMouse = (get_viewport().get_mouse_position() - Vector2(512, 300)) * Sensibilidade * delta
	get_viewport().warp_mouse(Vector2(512, 300))
	rotate_y(- RotacaoMouse.x)
	$Camera3D.rotate_x(- RotacaoMouse.y)
	
	if is_on_floor():
		VelocidadeGravidade = 0.0
	else:
		VelocidadeGravidade += gravity * delta
	velocity = Vector3(0, 0, 0)
	if Input.is_action_pressed("b_cima"):
		velocity += -transform.basis.z
	if Input.is_action_pressed("b_baixo"):
		velocity += transform.basis.z
	if Input.is_action_pressed("b_direita"):
		velocity += transform.basis.x
	if Input.is_action_pressed("b_esquerda"):
		velocity += -transform.basis.x
	if Input.is_action_pressed("b_pulo") and is_on_floor():
		VelocidadeGravidade = VelocidadePulo
	velocity = velocity.normalized() * Velocidade
	if not velocity.x == 0 or not velocity.y == 0:
		Animator.travel("andando")
	else:
		Animator.travel("parado")
	velocity += Vector3(0, VelocidadeGravidade, 0)
	pass
	
	if Input.is_action_pressed("b_sair"):
		get_tree().quit()
	
	move_and_slide()
	pass
