use <X-Wing Movement Dial.scad>
use <X-Wing Box.scad>
use <Box.scad>

box_width = 214;
box_depth = 214;
height = 40;
box_wall_thickness = 2;
inner_wall_thickness = 1.6;

boxProperties = createBoxProperties(box_width, box_depth, height, box_wall_thickness);

xwing_box(boxProperties) {
  
  box_inner_width = boxInnerWidth(boxProperties.x, box_wall_thickness);
  box_inner_depth = boxInnerDepth(boxProperties.y, box_wall_thickness);

  movement_dial_holder_surface(width = box_inner_width, depth = box_inner_depth, inner_wall_width = inner_wall_thickness);
}

translate([0, boxProperties.y + 10, 0]) {
 lid(boxProperties);  
}
