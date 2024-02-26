/// @description Insert description here
// You can write your code in this editor

var moveSpeed = 10;
var vx = 0;
var vy = 0;

if (keyboard_check(ord("W"))) vy -= moveSpeed;
if (keyboard_check(ord("S"))) vy += moveSpeed;
if (keyboard_check(ord("A"))) vx -= moveSpeed;
if (keyboard_check(ord("D"))) vx += moveSpeed;

collisionTileIndex = 16;

var nextX = x + vx;
var nextY = y + vy;

if (tilemap_get_at_pixel(WallTile, nextX, nextY) == collisionTileIndex) {
    vx = 0;
    vy = 0;
}

x += vx;
y += vy;


var halfWidth = sprite_get_width(sprite_index) / 2;
var halfHeight = sprite_get_height(sprite_index) / 2;

x = clamp(x, halfWidth, room_width - halfWidth);
y = clamp(y, halfHeight, room_height - halfHeight);


shootTimer += 1;
if (shootTimer >= shootInterval) {
    shootTimer = 0;
    //instance_create_layer(x, y, "Instances", obj_bullet);
}
