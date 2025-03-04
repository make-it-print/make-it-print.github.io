module small_base_holder(width = 43, depth = 10, height = 8, wall_thickness = 1.6) {
  cube(size=[wall_thickness, depth + wall_thickness, height]);
  translate([wall_thickness, 0, 0]) {
    cube(size=[width, wall_thickness, height]);

    translate([width, 0, 0]) {
      cube(size=[wall_thickness, depth + wall_thickness, height]);
    }
  }
}

module small_base_holder_surface(width, depth, wall_thickness = 1.6) {
  holder_width = 42;
  holder_depth = 10;
  holder_height = 8;

  row_count = floor(depth / (holder_depth + wall_thickness));
  column_count = floor(width / (holder_width + wall_thickness));

  small_base_holder_grid(row_count, column_count, holder_width, holder_depth, holder_height, wall_thickness);
}

module small_base_holder_grid(row_count = 10, column_count = 2, width = 43, depth = 10, height = 8, wall_thickness = 1.6) {
  for(x=[0:1:column_count-1]) {
    for(y=[0:1:row_count-1]) {
      translate([(width + wall_thickness) * x, (depth + wall_thickness) * y, 0]) {
        small_base_holder(width, depth, height, wall_thickness);
      }
    }

    translate([(width + wall_thickness) * x, (depth + wall_thickness) * row_count, 0]) {
      #cube(size=[width + wall_thickness * 2, wall_thickness, height]);
    }
  }
}

module box_compartment_corner(height = 40, wall_thickness = 1.6) {
  cube(size=[15, wall_thickness, height]);
  cube(size=[wall_thickness, 15, height]);
}

module box_compartment(width = 58, depth = 58, height = 40, wall_thickness = 1.6) {
  width = width + wall_thickness * 2;
  depth = depth + wall_thickness * 2;
  
  box_compartment_corner(height, wall_thickness);

  translate([width, 0, 0]) {
    rotate(90, [0, 0, 1]) {
      box_compartment_corner(height, wall_thickness);
    }

    translate([0, depth, 0]) {
      rotate(180, [0, 0, 1]) {
        box_compartment_corner(height, wall_thickness);
      }
    }
  }

  translate([0, depth, 0]) {
    rotate(270, [0, 0, 1]) {
      box_compartment_corner(height, wall_thickness);
    }
  }
}

module large_base_holder_compartment(size = 86, height = 40, wall_thickness = 1.6) {
  box_compartment(size, size, height, wall_thickness);
}

module medium_base_holder_compartment(size = 68, height = 40, wall_thickness = 1.6) {
  box_compartment(size, size, height, wall_thickness);
}

translate([0, 0, -10]) {
  %cube(size=[220-6,220-6, 10]);
}

small_base_holder_grid(18, 1);

translate([(42 + 1.6 * 2), 0, 0]) {
  large_base_holder_compartment();

  translate([86, 0, 0]) {
    medium_base_holder_compartment();
  }

  translate([86, 68 + 1.6 * 2, 0]) {
    box_compartment(68, 86 - 68);
  }
}
