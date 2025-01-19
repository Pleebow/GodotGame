extends Node2D

#Grid size and importing pipe textures
const grid_size = 10
const pipes = {
	"straight" : preload("res://imported/Pipe Straight.png"),
	"corner" : preload("res://imported/Pipe Corner.png"),
	"4way" : preload("res://imported/Pipe 4-Way.png"),
	"broken" : preload("res://imported/Pipe Broken.png")
} 

#Grid init
var grid = []
var flowing = false
func _ready():
	for i in range(grid_size):
		grid.append([])
		for j in range(grid_size):
			grid[i].append(null)


func draw_grid():
	for i in range(grid_size):
		for j in range(grid_size):
			if grid[i][j]:
				add_child(grid[i][j])

func is_valid_position(x, y):
	return x >= 0 and x < grid_size and y >= 0 and y < grid_size and grid[x][y] == null

func place_pipe(x, y, pipe_type):
	if is_valid_position(x, y):
		var pipe_instance = pipes[pipe_type].instance()
		pipe_instance.position = Vector2(x * 32, y * 32)
		grid[x][y] = pipe_instance
		add_child(pipe_instance)

func flow(x,y):
	if !flowing or !is_valid_position(x,y):
		return

func start_flow():
	flowing = true
	flow(1,1)

func flow_logic():
	for i in range(grid_size):
		for j in range(grid_size):
			if grid[i][j].get_pipe_type() == "straight":
				flow(i + 1, j)
				flow(i - 1, j)
			elif grid[i][j].get_pipe_type() == "corner":
				flow(i + 1, j); flow(i, j + 1)
			elif grid[i][j].get_pipe_type() == "4way":
				flow(i + 1, j); flow(i - 1, j); flow(i, j + 1); flow(i, j - 1)
			elif grid[i][j].get_pipe_type() == "broken":
				return

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		place_pipe(randf_range(0, grid_size - 1), randf_range(0, grid_size - 1), "straight")
