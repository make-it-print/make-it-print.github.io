use <X-Wing Movement Dial.scad>

module movement_dial_holder_surface(inner_wall_width = 1.6, width = 220, depth = 220) {
  movement_dial_width = 54;
  movement_dial_height = 8;
  movement_dial_depth = 8;
  movement_dial_hole_width = 37;
  
  movement_dial_row_depth = movement_dial_depth + inner_wall_width;
  row_count = floor((depth - inner_wall_width)/movement_dial_row_depth);
  column_count = floor(width/movement_dial_width);
  movement_dial_surface_depth = row_count * movement_dial_row_depth;
  movement_dial_surface_width = column_count * movement_dial_width;
  
  movement_dial_surface_y_offset = (depth - (movement_dial_surface_depth + inner_wall_width))/2;
  movement_dial_surface_x_offset = (width - movement_dial_surface_width)/2;
  
  translate([movement_dial_surface_x_offset, movement_dial_surface_y_offset, 0]) {  
    for(x=[0:movement_dial_width:width-movement_dial_width]) // repeat the following with two variants for x
    {
      for(i=[0:1:row_count-1])
      {
        translate([x,movement_dial_row_depth * i,0]) {
          if (i % 2 == 0) {
            movement_dial_holder_even(inner_wall_width, movement_dial_width, movement_dial_depth, movement_dial_height, movement_dial_hole_width);
          } else {
            movement_dial_holder_odd(inner_wall_width, movement_dial_width, movement_dial_depth, movement_dial_height, movement_dial_hole_width);
          }
        }
      }

      translate([x, movement_dial_surface_depth, 0]) {
        movement_dial_holder_separator(inner_wall_width, movement_dial_width, movement_dial_depth, movement_dial_height, movement_dial_hole_width);
      }
    }
  }
}


module movement_dial_holder_surface_v1(inner_wall_width = 1.6, width = 220, depth = 220) {
  movement_dial_width = 54;
  movement_dial_height = 8;
  movement_dial_depth = 8;
  movement_dial_hole_width = 37;
  
  movement_dial_full_depth = movement_dial_depth + inner_wall_width;
  movement_dial_row_depth = movement_dial_full_depth * 2;
  movement_dial_surface_depth = floor(depth/movement_dial_full_depth) * movement_dial_full_depth;
  movement_dial_surface_width = floor(width/movement_dial_width) * (movement_dial_width);
  
  movement_dial_surface_y_offset = (depth - (movement_dial_surface_depth + inner_wall_width*2))/2;
  movement_dial_surface_x_offset = (width - movement_dial_surface_width)/2;
  
  translate([movement_dial_surface_x_offset, movement_dial_surface_y_offset, 0]) {  
    for(x=[0:movement_dial_width:width-movement_dial_width]) // repeat the following with two variants for x
    {
      for(y=[0:movement_dial_row_depth:depth-(movement_dial_full_depth)]) // repeat again but this time for y
      {
        translate([x,y,0])
          movement_dial_holder_even(inner_wall_width, movement_dial_width, movement_dial_depth, movement_dial_height, movement_dial_hole_width);
      }
    }
    
    for(x=[0:movement_dial_width:width-movement_dial_width]) // repeat the following with two variants for x
    {
      for(y=[movement_dial_full_depth:movement_dial_row_depth:depth-movement_dial_full_depth]) // repeat again but this time for y
      {
        translate([x,y,0])
          movement_dial_holder_odd(inner_wall_width, movement_dial_width, movement_dial_depth, movement_dial_height, movement_dial_hole_width);
      }
    }
    
    translate([0, movement_dial_surface_depth, 0]) {
      cube(size=[movement_dial_surface_width, inner_wall_width, movement_dial_height]);
    }
  }
}

translate([0, 0, -10]) {
  %cube(size=[220,220, 10]);
}

movement_dial_holder_surface();