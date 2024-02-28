/// @description Insert description here
// You can write your code in this editor
var vx = 0;
var vy = 0;

#region Inputs

if (keyboard_check(ord("W"))) vy -= moveSpeed;
if (keyboard_check(ord("S"))) vy += moveSpeed;
if (keyboard_check(ord("A"))) vx -= moveSpeed;
if (keyboard_check(ord("D"))) vx += moveSpeed;

shoot = mouse_check_button(mb_left);
bombInput = mouse_check_button(mb_right);


collisionTileIndex = 16;

var nextX = x + vx;
var nextY = y + vy;

if (place_meeting(nextX, y, obj_wall)) {
    vx = 0;
}

if (place_meeting(x, nextY, obj_wall)) {
    vy = 0;
}

//normalize vector
if (vx + vy > point_distance(0,0,vx,vy)) {
	vx *= moveSpeed/point_distance(0,0,vx,vy);
	vy *= moveSpeed/point_distance(0,0,vx,vy);
}

x += vx;
y += vy;


var halfWidth = sprite_get_width(sprite_index) / 2;
var halfHeight = sprite_get_height(sprite_index) / 2;

#endregion

x = clamp(x, halfWidth, room_width - halfWidth);
y = clamp(y, halfHeight, room_height - halfHeight);

self.image_xscale = 0.5;
self.image_yscale = 0.5;
self.image_angle = point_direction(x, y, mouse_x, mouse_y);

if (global.richochet) {
	bulletLimit = 10;
}

if shoot {
	audio_play_sound(laserShoot, 0, false);
	attack_cooldown +=1;
	if(attack_cooldown >= 8 && instance_number(obj_bullet) < bulletLimit) {
	    bullet = instance_create_layer(x, y, "Instances", obj_bullet);
	    bullet.speed = 13;
	    bullet.direction= point_direction(x, y, mouse_x, mouse_y);
	    bullet.image_angle = bullet.direction;
	    attack_cooldown = 0;
	}
}


function doGraze() {
	for (var i = 0; i < instance_number(oEnemBullet); ++i;) {
		currEnem = instance_find(oEnemBullet, i);
		if (point_distance(x, y, currEnem.x, currEnem.y) <= grazeDistance) {
			grazeMeter++;
		}
	}
	
	if (grazeMeter >= 100) {
		canBomb = true;
		grazeMeter = 100;
	}
}

function bomb() {
	if (playerTimer > 0) {

		for (var i = 0; i < instance_number(oEnemBullet); ++i;) {
			currEnem = instance_find(oEnemBullet, i);
			if (point_distance(x, y, currEnem.x, currEnem.y) <= bombDistance) {
				instance_destroy(currEnem.id);
			}
		}
		grazeMeter = 0;
		playerTimer--;
	}
		
	if (playerTimer == 0) {
		canBomb = false;
		playerTimer = -1;
	}
}


if (playerLives <= 0) {
	//teleport to death limbo room
	room_goto(rmGameOver);
	playerLives = 3;
	global.richochet = false;
	global.graze = false;
	global.healthBoost = 0;
}

if (bombInput && canBomb) {
	playerTimer = room_speed * 0.5;
	bomb();
}

if (global.graze) {
	doGraze();
}