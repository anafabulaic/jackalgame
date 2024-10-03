extends Node

var player_ref: Player

enum {
	PLAYER_READY,				# Player is allowed to do anything.
	PLAYER_IN_INVENTORY, 		# Player is in inventory. Disable movement and interact functions.
	PLAYER_IN_SCENE_TRANSITION, 	# Player is in a scene transition. Disable all.
	PLAYER_IN_CUTSCENE, 			# Player is in a cutscene. Disable all.
	PLAYER_IN_INSPECTING
}
var player_state: int = PLAYER_READY

func set_player_state(state: int) -> void:
	player_state = state
