include <Box Properties.scad>
use <X-Wing Movement Dial.scad>
use <X-Wing Box.scad>
use <Box.scad>

production = true;
box_width = production ? 214 : 110;
box_depth = production ? 214 : 100;
height = 40;
box_wall_thickness = 2;
inner_wall_thickness = 1.6;

boxProperties = createBoxProperties(box_width, box_depth, height, box_wall_thickness, tolerance = 0.2);

//xwing_box(boxProperties);
box_insert(boxProperties, [200, 0, 0, 0]) {
  box_inner_width = boxInnerWidth(boxProperties);
  box_inner_depth = boxInnerDepth(boxProperties);

  translate([-boxProperties[InnerWallThickness] - boxProperties[Tolerance], -boxProperties[InnerWallThickness] - boxProperties[Tolerance], 0]) {
    *cube(size=[box_inner_width, box_inner_depth, 10]);
    movement_dial_holder_surface(width = box_inner_width, depth = box_inner_depth, inner_wall_width = 1);
  }
}

//translate([0, boxProperties.y + 10, 0]) {
// lid(boxProperties);  
//}
