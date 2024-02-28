if (point_distance(obj_player.x, obj_player.y, x, y) < ENEM_DISTANCE) {
	move_towards_point(obj_player.x, obj_player.y, trackShooterSpeed);
	shoot();
}

function shoot() {
	attack_cooldown +=1;
	if(attack_cooldown >= 20) {
	    bullet = instance_create_layer(x, y, "Instances", oEnemBullet);
	    bullet.speed = 13;
	    bullet.direction= point_direction(x, y, obj_player.x, obj_player.y);
	    bullet.image_angle = bullet.direction;
	    attack_cooldown = 0;
	}
}

if (trackerShooterLives <= 0) {
	chance = random(100);
	if (chance <= global.dropRate && dm.currLevel > 10) {
		powerup = instance_create_layer(x, y, "Instances", choose(oRichochet, oBomb));
	}
	instance_destroy();
}
