extends Node2D


@onready var tilemap = $TileMap
@onready var player_piece: Sprite2D = $player1spriteGreen
@onready var rollresult = $rollresult
var current_tile: int = 1


func _ready() -> void:
	move_piece_to_tile(current_tile)


func get_tile_position(tile_num: int) -> Vector2i:
	var index := tile_num - 1
	@warning_ignore("integer_division")
	var row := index / 10
	var col := index % 10
	if row % 2 == 1:
		col = 9 - col
	return Vector2i(col, 9 - row)  # Adjust for top-down tilemap

func move_piece_to_tile(tile_num: int):
	var board_pos: Vector2i = get_tile_position(tile_num)      # e.g., (0, 9)
	var tile_per_square = 6                                     # 6x6 tiles per square
	var tile_offset: Vector2i = board_pos * tile_per_square     # scale to full board
	var center_tile: Vector2i = tile_offset + Vector2i(3, 3)     # center of 6x6

	var cell_pos: Vector2 = tilemap.map_to_local(center_tile)   # convert to local
	#var global_pos: Vector2 = tilemap.to_global(cell_pos)       # convert to global

	player_piece.global_position = cell_pos       # move piece

	print("Moving to tile", tile_num, " -> tile grid:", center_tile, " -> pos:", player_piece.global_position)



func _on_dicerollbutton_pressed():
	var dice_roll = randi_range(1, 6) # use randi_range(1, 6) for a six-sided die instead of randi() % 6 + 1
	$rollresult.text = "u got" + str(dice_roll)
	var target_tile = current_tile + dice_roll
	if target_tile > 100:
		target_tile = 100
	
	# Move one tile at a time with delay
	for i in range(current_tile + 1, target_tile + 1):
		move_piece_to_tile(i)
		await get_tree().create_timer(0.5).timeout

	current_tile = target_tile
	print(player_piece.global_position)
