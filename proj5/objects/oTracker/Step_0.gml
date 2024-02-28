//var test = (point_distance(obj_player.x, obj_player.y, x, y));
//show_debug_message(string(test));
if (point_distance(obj_player.x, obj_player.y, x, y) < ENEM_DISTANCE) {
	show_debug_message("close to tracker");
	self.image_angle = point_direction(x, y, obj_player.x, obj_player.y);
	move_towards_point(obj_player.x, obj_player.y, trackerSpeed);
	//track();
}
else {
	speed = 0;
}