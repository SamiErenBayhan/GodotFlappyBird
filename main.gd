extends Node2D

var bird_position = Vector2(100, 300)#anlık piksel konum
var velocity = Vector2.ZERO# anlık hareketi sıfır

const GRAVITY = 600#yerçekimi değeri  #Hız
const JUMP_FORCE = -300#yerçekimine karşı gelen eksi zıplama değeri

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta #Her karede yerçekimini kuşun Y hızına ekliyoruz. Kuş gitgide hızlanarak düşüyor
	bird_position += velocity * delta #burada da kuşun pozisyonunu düşürüyoruz ve pürüzsük bir şekilde hızlanarak düşüyor
	queue_redraw()

func _draw():
	var bird_rect = Rect2(bird_position, Vector2(32,32)) 
	draw_rect(bird_rect, Color.BLUE)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		velocity.y = JUMP_FORCE
		
