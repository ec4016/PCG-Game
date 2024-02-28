/// @DnDAction : YoYo Games.Common.Execute_Code
/// @DnDVersion : 1
/// @DnDHash : 36CEAC92
/// @DnDArgument : "code" ""


/// @DnDAction : YoYo Games.Drawing.Draw_Value
/// @DnDVersion : 1
/// @DnDHash : 4596230B
/// @DnDArgument : "x" "500"
/// @DnDArgument : "y" "300"
/// @DnDArgument : "caption" ""Game Over. Press Any Key to Restart.""
draw_text(500, 300, string("Game Over. Press Any Key to Restart.") + "");

/// @DnDAction : YoYo Games.Drawing.Set_Alignment
/// @DnDVersion : 1.1
/// @DnDHash : 70D90709
/// @DnDArgument : "halign" "fa_center"
/// @DnDArgument : "valign" "fa_middle"
draw_set_halign(fa_center);
draw_set_valign(fa_middle);