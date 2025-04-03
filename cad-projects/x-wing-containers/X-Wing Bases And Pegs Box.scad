use <Box.scad>
use <X-Wing Box.scad>
use <Box Compartment.scad>
use <X-Wing Ship Base Holder.scad>
use <X-Wing Movement Dial.scad>

box_width = 214;
box_depth = 214;
height = 40;
box_wall_thickness = 2;
inner_wall_thickness = 1.6;

xwing_box(width = box_width, depth = box_depth, height = height, inner_wall_thickness = inner_wall_thickness) {
  medium_base_holder_width = mediumBaseHolderSize();
  large_base_holder_width = largeBaseHolderSize();
  
  box_inner_width = boxInnerWidth(box_width, box_wall_thickness);
  box_inner_depth = boxInnerDepth(box_depth, box_wall_thickness);

  small_base_holders_width = smallBaseHolderWidth(inner_wall_thickness);

  dials_width = box_width - 4 - small_base_holders_width;
  dials_depth = box_depth - 4 - large_base_holder_width - inner_wall_thickness;

  translate([-inner_wall_thickness, -inner_wall_thickness, 0]) {
    small_base_holder_surface(smallBaseHolderWidth(inner_wall_thickness) + inner_wall_thickness, box_inner_depth + inner_wall_thickness * 2, wall_thickness = inner_wall_thickness);
  
    translate([small_base_holders_width, 0, 0]) {
      large_base_holder_compartment(depth = large_base_holder_width + 4, wall_thickness = inner_wall_thickness);
  
      translate([large_base_holder_width + inner_wall_thickness, 0, 0]) {
        medium_base_holder_compartment(wall_thickness = inner_wall_thickness);
      }
  
      translate([large_base_holder_width + inner_wall_thickness, medium_base_holder_width + inner_wall_thickness, 0]) {
        box_compartment(medium_base_holder_width, large_base_holder_width - medium_base_holder_width - inner_wall_thickness + 4);
      }
  
      translate([inner_wall_thickness, large_base_holder_width + inner_wall_thickness * 2, 0]) {
        *cube(size=[dials_width, dials_depth, 10]);
        dialsColumnCount = movementDialColumnCount(dials_width);
        dialsWidth = movementDialSurfaceWidth(dialsColumnCount);
        movement_dial_holder_surface(width = dials_width, depth = dials_depth, inner_wall_width = inner_wall_thickness);
      }
    }
  }
}