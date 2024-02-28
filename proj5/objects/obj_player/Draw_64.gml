for (i = 0; i < playerLives; i++) {
  draw_sprite(heart, 0, i*64 + 10, 10);
}

draw_text(10, 100, "canBomb: " + string(canBomb));
draw_text(10, 174, "Meter: " + string(grazeMeter));