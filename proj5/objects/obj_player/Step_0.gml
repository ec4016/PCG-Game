/// @description Insert description here
// You can write your code in this editor

var moveSpeed = 10;
var vx = 0;
var vy = 0;

#region Inputs

if (keyboard_check(ord("W"))) vy -= moveSpeed;
if (keyboard_check(ord("S"))) vy += moveSpeed;
if (keyboard_check(ord("A"))) vx -= moveSpeed;
if (keyboard_check(ord("D"))) vx += moveSpeed;
shoot = mouse_check_button(mb_left);

collisionTileIndex = 16;

var nextX = x + vx;
var nextY = y + vy;

if (place_meeting(nextX, nextY, obj_wall)) {
    vx = 0;
    vy = 0;
}

x += vx;
y += vy;


var halfWidth = sprite_get_width(sprite_index) / 2;
var halfHeight = sprite_get_height(sprite_index) / 2;

#endregion

x = clamp(x, halfWidth, room_width - halfWidth);
y = clamp(y, halfHeight, room_height - halfHeight);

self.image_angle = point_direction(x, y, mouse_x, mouse_y);

if shoot {
	attack_cooldown +=1;
	if(attack_cooldown >= 10) {
	    bullet = instance_create_layer(x, y, "Instances", obj_bullet);
	    bullet.speed = 13;
	    bullet.direction= point_direction(x, y, mouse_x, mouse_y);
	    bullet.image_angle = bullet.direction;
	    attack_cooldown = 0;
	}
}

if (!place_meeting(x+4, y, [oEnemBullet, oTracker])) {
	health -= 1;
}

if (health <= 0) {
	//teleport to main hub
	health = 3;
}