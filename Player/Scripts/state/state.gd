class_name State extends Node

# Biến dùng chung cho các trạng thái con
static var player: Player
static var state_machine: PlayerStateMachine

func _ready() -> void:
	pass

# Gọi khi trạng thái được kích hoạt
func Enter() -> void:
	pass

# Gọi khi trạng thái được khởi tạo trong máy trạng thái
func init() -> void:
	pass

# Gọi khi trạng thái bị thay thế
func Exit() -> void:
	pass

# Xử lý logic khung hình
# Trả về trạng thái mới (nếu có), hoặc null để giữ nguyên trạng thái
func Process(_delta: float) -> State:
	return null

# Xử lý logic vật lý
func Physics(_delta: float) -> State:
	return null

# Xử lý input chưa xử lý
func HandleInput(_event: InputEvent) -> State:
	return null
