class_name State extends Node

## Lưu tham chiếu đến người chơi mà State này thuộc về
static var player: Player
static var state_machine: PlayerStateMachine

func _ready():
	pass # Hàm này được gọi khi node sẵn sàng (được thêm vào scene).

## Hàm được gọi khi khởi tạo State này
func init() -> void:
	pass

## Hàm được gọi khi người chơi chuyển sang State này
func enter() -> void:
	pass

## Hàm được gọi khi người chơi thoát khỏi State này
func exit() -> void:
	pass

## Hàm được gọi mỗi khung hình (frame) trong quá trình xử lý logic không liên quan đến vật lý
func process(_delta: float) -> State:
	return null  # Trả về null hoặc một State mới nếu muốn chuyển trạng thái

## Hàm được gọi trong mỗi khung hình vật lý (physics frame), dùng cho xử lý liên quan đến vật lý
func physics(_delta: float) -> State:
	return null  # Trả về null hoặc một State mới nếu muốn chuyển trạng thái

## Hàm xử lý các sự kiện input trong State này (nhấn phím, chuột, v.v.)
func handle_input(_event: InputEvent) -> State:
	return null  # Trả về null hoặc một State mới nếu muốn chuyển trạng thái
