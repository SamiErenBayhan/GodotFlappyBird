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

var score = 0

func _ready() -> void:
	pass 

func _physics_process(delta):
	velocity.y += GRAVITY * delta 
	bird_position += velocity * delta 
	
	if pipes.size() > 0 and pipes[0] != null:
		if pipes[0].x < -100: 
			pipes.remove_at(0)
	
	for i in range(pipes.size()):
		if i < pipes.size(): 
			pipes[i].x -= PIPE_SPEED * delta 
	
	for i in range(pipes.size()):
		if i < pipes.size():
			if pipes[i].x < 100 and pipes[i].x > 100 - (PIPE_SPEED * delta):
				score += 1
	
	var bird_rect = Rect2(bird_position, Vector2(32, 32))
	for i in range(pipes.size()):
		var rects = get_pipe_rects(i)
		if rects[0] != Rect2():
			if bird_rect.intersects(rects[0]) or bird_rect.intersects(rects[1]):
				game_over()
				return
	
	queue_redraw()

func _draw():
	# 1. Kuşumuzu çiziyoruz
	var bird_rect = Rect2(bird_position, Vector2(32, 32)) 
	draw_rect(bird_rect, Color.BLUE)
	
	if pipes.size() == 0:
		return
		
	# 2. Boruları çiziyoruz (Yazı falan yok, tertemiz!)
	for i in range(pipes.size()):
		if i >= pipes.size(): break
		var pipe_pos = pipes[i]
		
		var bottom_rect = Rect2(pipe_pos, Vector2(PIPE_WIDTH, PIPE_HEIGHT))
		draw_rect(bottom_rect, Color.GREEN)
		
		var top_pos_y = pipe_pos.y - GAP_SIZE - PIPE_HEIGHT
		var top_rect = Rect2(Vector2(pipe_pos.x, top_pos_y), Vector2(PIPE_WIDTH, PIPE_HEIGHT))
		draw_rect(top_rect, Color.GREEN)
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
	bird_position = Vector2(100, 300)
	velocity = Vector2.ZERO
	pipes.clear()
	score = 0 
	if has_node("PipeTimer"):
		$PipeTimer.stop()
	elif has_node("Timer"): # Eğer adı düz Timer ise onu durdur
		$Timer.stop()
	queue_redraw()
	
func get_pipe_rects(index: int) -> Array:
	if pipes.size() == 0 or index >= pipes.size():
		return [Rect2(), Rect2()]
	
	var pipe_pos = pipes[index]
	var bottom_rect = Rect2(pipe_pos, Vector2(PIPE_WIDTH, PIPE_HEIGHT))
	
	var top_pos_y = pipe_pos.y - GAP_SIZE - PIPE_HEIGHT
	var top_rect = Rect2(Vector2(pipe_pos.x, top_pos_y), Vector2(PIPE_WIDTH, PIPE_HEIGHT))
	
	return [bottom_rect, top_rect] # [0] alt boru, [1] üst boru olacak
