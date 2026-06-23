extends Node2D

var bird_position = Vector2(100, 300)#anlık piksel konum
var velocity = Vector2.ZERO# anlık hareketi sıfır

const GRAVITY = 600#yerçekimi değeri  #Hız
const JUMP_FORCE = -300#yerçekimine karşı gelen eksi zıplama değeri

var pipes = []
const PIPE_SPEED = 200
const PIPE_WIDTH = 75
const PIPE_HEIGHT = 500

const GAP_SIZE = 200 # İki boru arasındaki kuşun geçeceği piksel boşluğu

func _ready() -> void:
	pass 

func _physics_process(delta):
	velocity.y += GRAVITY * delta #Her karede yerçekimini kuşun Y hızına ekliyoruz. Kuş gitgide hızlanarak düşüyor
	bird_position += velocity * delta #burada da kuşun pozisyonunu düşürüyoruz ve pürüzsük bir şekilde hızlanarak düşüyor
	
	if pipes.size() > 0:
		if pipes[0].x < -50:
			pipes.remove_at(0)
	
	for i in range(pipes.size()):
		pipes[i].x -= PIPE_SPEED * delta #x değerini sürekli küçülterek boruların sağdan sola gitmesini sağlıyoruz
	
	var bird_rect = Rect2(bird_position, Vector2(32,32))
	
	for i in range(pipes.size()):
		var rects = get_pipe_rects(i)
		if bird_rect.intersects(rects[0]) or bird_rect.intersects(rects[1]):
			game_over()
	
	queue_redraw()

func _draw():
	var bird_rect = Rect2(bird_position, Vector2(32,32)) 
	draw_rect(bird_rect, Color.BLUE)
	
	for i in range(pipes.size()):
		var rects = get_pipe_rects(i) 
		draw_rect(rects[1], Color.GREEN)
		draw_rect(rects[0], Color.YELLOW)
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
			if $Pipe_timer.is_stopped():
				$Pipe_timer.start()
			velocity.y = JUMP_FORCE
		
func _on_pipe_timer_timeout() -> void:
	var random_y = randi_range(200, 500)
	var new_pipe = Vector2(800, random_y)
	pipes.append(new_pipe)	
	
func game_over():
	bird_position = Vector2(100, 300)#anlık piksel konum
	velocity = Vector2.ZERO
	$Pipe_timer.stop()
	pipes.clear()
	queue_redraw()
	
func get_pipe_rects(index: int) -> Array:
	if pipes.size() == 0 or index >= pipes.size():
		return [Rect2(), Rect2()]
	
	var pipe_pos = pipes[index]
	var bottom_rect = Rect2(pipe_pos, Vector2(PIPE_WIDTH, PIPE_HEIGHT))
	
	var top_pos_y = pipe_pos.y - GAP_SIZE - PIPE_HEIGHT
	var top_rect = Rect2(Vector2(pipe_pos.x, top_pos_y), Vector2(PIPE_WIDTH, PIPE_HEIGHT))
	
	return [bottom_rect, top_rect] # [0] alt boru, [1] üst boru olacak
