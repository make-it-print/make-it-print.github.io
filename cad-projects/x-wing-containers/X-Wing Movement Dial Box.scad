use <X-Wing Movement Dial.scad>
use <X-Wing Box.scad>
use <Box.scad>

box_width = 214;
box_depth = 214;
height = 40;
box_wall_thickness = 2;
inner_wall_thickness = 1.6;

xwing_box(width = box_width, depth = box_depth, height = height, inner_wall_thickness = inner_wall_thickness) {
  
  box_inner_width = boxInnerWidth(box_width, box_wall_thickness);
  box_inner_depth = boxInnerDepth(box_depth, box_wall_thickness);

  movement_dial_holder_surface(width = box_inner_width, depth = box_inner_depth, inner_wall_width = inner_wall_thickness);
}

translate([0, box_depth + 10, 0]) {
 lid(width = box_width, depth = box_depth);  
}
