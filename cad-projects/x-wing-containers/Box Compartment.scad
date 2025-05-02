module box_compartment_corner(width = 15, depth = 15, height = 40, wall_thickness = 1.6) {
  cube(size=[width, wall_thickness, height]);
  cube(size=[wall_thickness, depth, height]);
}

function boxCompartmentOuterWidth(width, wall_thickness) = width + wall_thickness * 2;
function boxCompartmentOuterDepth(depth, wall_thickness) = depth + wall_thickness * 2;

module box_compartment(width = 58, depth = 58, height = 40, wall_thickness = 1.6, cornerSize = [15, 15], base_height = 0) {
  width = boxCompartmentOuterWidth(width, wall_thickness);
  depth = boxCompartmentOuterDepth(depth, wall_thickness);
  
  box_compartment_corner(height = height, wall_thickness = wall_thickness, width = cornerSize[0], depth = cornerSize[1]);
  cube(size=[width, wall_thickness, base_height]);
  cube(size=[wall_thickness, depth, base_height]);

  translate([width, 0, 0]) {
    translate([-wall_thickness, 0, 0]) {
      cube(size=[wall_thickness, depth, base_height]);
    }

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
    translate([0, -wall_thickness, 0]) {
      cube(size=[width, wall_thickness, base_height]);
    }

    rotate(270, [0, 0, 1]) {
      box_compartment_corner(height = height, wall_thickness = wall_thickness, width = cornerSize[1], depth = cornerSize[0]);
    }
  }
}