if (abs(obj_player.x - self.x) > ENEM_DISTANCE || abs(obj_player.y - self.y) > ENEM_DISTANCE) {
	move_towards_point(obj_player.x, obj_player.y, speed);
	//track();
}

//function track() {
//	//track player, die on contact
//	self.speed = 13;
//	self.direction= point_direction(self.x, self.y, obj_player.x, obj_player.x);
//	bullet.image_angle = bullet.direction;
//	attack_cooldown = 0;

//}