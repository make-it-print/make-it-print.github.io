module box_compartment_corner(width = 15, depth = 15, height = 40, wall_thickness = 1.6) {
  cube(size=[width, wall_thickness, height]);
  cube(size=[wall_thickness, depth, height]);
}

module box_compartment(width = 58, depth = 58, height = 40, wall_thickness = 1.6, cornerSize = [15, 15]) {
  width = width + wall_thickness * 2;
  depth = depth + wall_thickness * 2;
  
  box_compartment_corner(height = height, wall_thickness = wall_thickness, width = cornerSize[0], depth = cornerSize[1]);

  translate([width, 0, 0]) {
    rotate(90, [0, 0, 1]) {
      box_compartment_corner(height = height, wall_thickness = wall_thickness, width = cornerSize[1], depth = cornerSize[0]);
    }

    translate([0, depth, 0]) {
      rotate(180, [0, 0, 1]) {
        box_compartment_corner(height = height, wall_thickness = wall_thickness, width = cornerSize[0], depth = cornerSize[1]);
      }
    }
  }

  translate([0, depth, 0]) {
    rotate(270, [0, 0, 1]) {
      box_compartment_corner(height = height, wall_thickness = wall_thickness, width = cornerSize[1], depth = cornerSize[0]);
    }
  }
}