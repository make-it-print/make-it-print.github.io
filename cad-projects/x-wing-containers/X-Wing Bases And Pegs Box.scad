use <X-Wing Box.scad>
use <X-Wing Ship Base Holder.scad>
use <X-Wing Movement Dial Surface.scad>

height = 40;
inner_wall_thickness = 1.6;

xwing_box(height = height, inner_wall_thickness = inner_wall_thickness) {
  small_base_holder_width = 42;
  medium_base_holder_width = 68;
  large_base_holder_width = 86;
  box_width = 214;

  small_base_holders_width = small_base_holder_width + inner_wall_thickness;

  dials_width = box_width - 4 - small_base_holders_width - inner_wall_thickness;
  dials_depth = box_width - 4 - large_base_holder_width - inner_wall_thickness;

  small_base_holder_grid(18, 1, width = small_base_holder_width, wall_thickness = inner_wall_thickness);

  translate([small_base_holders_width, -inner_wall_thickness, 0]) {
    large_base_holder_compartment(wall_thickness = inner_wall_thickness);

    translate([large_base_holder_width + inner_wall_thickness, 0, 0]) {
      medium_base_holder_compartment();
    }

    translate([large_base_holder_width + inner_wall_thickness, medium_base_holder_width + inner_wall_thickness, 0]) {
      box_compartment(medium_base_holder_width, large_base_holder_width - medium_base_holder_width - inner_wall_thickness);
    }

    translate([0, large_base_holder_width, 0]) {
      movement_dial_holder_surface(width = dials_width, depth = dials_depth);
    }
  }
}