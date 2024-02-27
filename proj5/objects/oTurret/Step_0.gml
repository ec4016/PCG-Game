if ((obj_player.x - self.x) > ENEM_DISTANCE || (obj_player.y - self.y) > ENEM_DISTANCE) {
	shoot();
}

function shoot() {
	//spawn oEnemBullets
	attack_cooldown +=1;
	if(attack_cooldown >= 15) {
	    bullet = instance_create_layer(x, y, "Instances", obj_bullet);
	    bullet.speed = 13;
	    bullet.direction= point_direction(x, y, mouse_x, mouse_y);
	    bullet.image_angle = bullet.direction;
	    attack_cooldown = 0;
	}
}