if (abs(obj_player.x - self.x) > ENEM_DISTANCE || abs(obj_player.y - self.y) > ENEM_DISTANCE) {
	move_towards_point(obj_player.x, obj_player.y, speed);
	shoot();
}