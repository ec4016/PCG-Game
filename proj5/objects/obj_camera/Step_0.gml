/// @description Insert description here
// You can write your code in this editor

var cam, playerX, playerY, viewW, viewH;



player_viewW = 16*60;
player_viewH = 9*60;

global_viewW = 2048;
global_viewH = 2048/16*9;

window_set_size(player_viewW, player_viewH);


cam = view_camera[0];

if(keyboard_check_pressed(ord("O"))){
	camera_mode = 1 - camera_mode;
	
	canToggleCameraMode = false;
	show_debug_message("Camera Mode: " + string(camera_mode) + ", Can Toggle: " + string(canToggleCameraMode));
}
else if(!keyboard_check(ord("O"))){
	canToggleCameraMode = true;
}


if(camera_mode == 0)
{
	playerX = obj_player.x;
	playerY = obj_player.y;
	camera_set_view_pos(cam, playerX - player_viewW / 2, playerY - player_viewH / 2);

	camera_set_view_size(cam, player_viewW, player_viewH);
}
else
{
	camera_set_view_pos(cam, 0, 0);
    camera_set_view_size(cam, global_viewW, global_viewH);
}




