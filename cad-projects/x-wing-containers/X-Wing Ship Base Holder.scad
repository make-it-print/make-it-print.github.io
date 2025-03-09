function smallBaseHolderWidth(wall_thickness = 1.6) = 41 + wall_thickness;
function smallBaseHolderDepth(wall_thickness = 1.6) = 9 + wall_thickness;

module small_base_holder(height = 8, wall_thickness = 1.6) {
  width = smallBaseHolderWidth(wall_thickness);
  depth = smallBaseHolderDepth(wall_thickness);
  cornerWidth = 10;

  box_compartment_corner(height = height, wall_thickness = wall_thickness, width = cornerWidth, depth = depth);

  translate([width + wall_thickness, 0, 0]) {
    rotate(90, [0, 0, 1]) {
      box_compartment_corner(height = height, wall_thickness = wall_thickness, width = depth, depth = cornerWidth);
    }
  }
}

module small_base_holder_surface(width, depth, wall_thickness = 1.6) {
  holder_width = smallBaseHolderWidth(wall_thickness);
  holder_depth = smallBaseHolderDepth(wall_thickness);
  holder_height = 8;

  row_count = floor(depth / holder_depth);
  column_count = floor(width / holder_width);

  small_base_holder_grid(row_count, column_count, holder_height, wall_thickness);
}

module small_base_holder_grid(row_count = 10, column_count = 2, height = 8, wall_thickness = 1.6) {
  width = smallBaseHolderWidth(wall_thickness);
  depth = smallBaseHolderDepth(wall_thickness);
  for(x=[0:1:column_count-1]) {
    for(y=[0:1:row_count-1]) {
      translate([width * x, depth * y, 0]) {
        small_base_holder(height, wall_thickness);
      }
    }

    translate([width * x, 0, 0]) {
      cube(size=[width + wall_thickness, wall_thickness, height]);
      
      translate([0, depth * row_count, 0]) {
        cube(size=[width + wall_thickness, wall_thickness, height]);
      }
    }
  }
}

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

module large_base_holder_compartment(size = 86, height = 40, wall_thickness = 1.6) {
  box_compartment(size, size, height, wall_thickness);
}

module medium_base_holder_compartment(size = 68, height = 40, wall_thickness = 1.6) {
  box_compartment(size, size, height, wall_thickness);
}

translate([0, 0, -10]) {
  %cube(size=[220-6,220-6, 10]);
}

inner_wall_thickness = 1.6;
rowCount = 6;

box_compartment(
  width = smallBaseHolderWidth(inner_wall_thickness) - inner_wall_thickness, 
  depth = smallBaseHolderDepth(inner_wall_thickness) * rowCount - inner_wall_thickness,
  height = 40,
  cornerSize = [10, 5]);
translate([0, 0, 0]) {
  small_base_holder_grid(rowCount, 1);
}

