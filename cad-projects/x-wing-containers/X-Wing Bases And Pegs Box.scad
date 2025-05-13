include <Box Properties.scad>
use <Box.scad>
use <X-Wing Box.scad>
use <Box Compartment.scad>
use <X-Wing Ship Base Holder.scad>
use <X-Wing Movement Dial.scad>

boxProperties = createBoxProperties(
  width = 214, 
  depth = 214, 
  height = 40, 
  wall_thickness = 2, 
  tolerance = 0.2, 
  inner_wall_thickness = 1.6);

//xwing_box(boxProperties);
box_insert(boxProperties) {
  box_inner_width = boxInsertWidth(boxProperties);
  box_inner_depth = boxInsertDepth(boxProperties);

  large_base_holder_width = largeBaseHolderSize();
  large_base_holder_depth = largeBaseHolderSize() + 9.4;

  small_base_holders_width = smallBaseHolderWidth(boxProperties[InnerWallThickness]);

  medium_base_holder_width = box_inner_width - large_base_holder_width - small_base_holders_width - boxProperties[InnerWallThickness] * 3;
  medium_base_holder_depth = mediumBaseHolderSize();

  compartmentBaseHeight = 6;

  

  dials_width = box_inner_width - small_base_holders_width - boxProperties[InnerWallThickness];
  dials_depth = box_inner_depth - large_base_holder_depth - boxProperties[InnerWallThickness];

  translate([-boxProperties[InnerWallThickness], -boxProperties[InnerWallThickness], 0]) {
    small_base_holder_surface(smallBaseHolderWidth(boxProperties[InnerWallThickness]) + boxProperties[InnerWallThickness], box_inner_depth, wall_thickness = boxProperties[InnerWallThickness]);
  
    translate([small_base_holders_width, 0, 0]) {
      large_base_holder_compartment(
        depth = large_base_holder_depth, 
        wall_thickness = boxProperties[InnerWallThickness], 
        base_height = compartmentBaseHeight,
        cornerSize = [25, 25]);
  
      translate([large_base_holder_width + boxProperties[InnerWallThickness], 0, 0]) {
        medium_base_holder_compartment(
          width = medium_base_holder_width, 
          wall_thickness = boxProperties[InnerWallThickness], 
          base_height = compartmentBaseHeight,
          cornerSize = [25, 25]);
      }
  
      translate([large_base_holder_width + boxProperties[InnerWallThickness], medium_base_holder_depth + boxProperties[InnerWallThickness], 0]) {
        box_compartment(
          medium_base_holder_width, 
          large_base_holder_depth - medium_base_holder_depth - boxProperties[InnerWallThickness], 
          base_height = compartmentBaseHeight,
          cornerSize = [25, 20]);
      }
  
      translate([boxProperties[InnerWallThickness], large_base_holder_depth + boxProperties[InnerWallThickness], 0]) {
        *cube(size=[dials_width, dials_depth, 10]);
        dialsColumnCount = movementDialColumnCount(dials_width);
        dialsWidth = movementDialSurfaceWidth(dialsColumnCount);
        movement_dial_holder_surface(width = dials_width, depth = dials_depth, inner_wall_width = 1);
      }
    }
  }
}