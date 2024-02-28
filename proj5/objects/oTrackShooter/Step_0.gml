if (point_distance(obj_player.x, obj_player.y, x, y) < ENEM_DISTANCE) {
	move_towards_point(obj_player.x, obj_player.y, speed);
	shoot();
}