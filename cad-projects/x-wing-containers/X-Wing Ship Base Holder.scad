use <Box Compartment.scad>

function smallBaseHolderWidth(wall_thickness = 1.6) = 41 + wall_thickness;
function smallBaseHolderDepth(wall_thickness = 1.6) = 9 + wall_thickness;

module small_base_holder(height = 8, wall_thickness = 1.6, depth) {
  width = smallBaseHolderWidth(wall_thickness);
  depth = is_undef(depth) ? smallBaseHolderDepth(wall_thickness) : depth;
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
  holder_height = 9;

  endOffset = 5;
  startOffset = holder_depth - endOffset;

  row_count = floor((depth - endOffset) / holder_depth);
  column_count = floor(width / holder_width);
  
  for(x=[0:1:column_count-1]) {
    translate([holder_width * x, 0, 0]) {
      cube(size=[holder_width + wall_thickness, wall_thickness, holder_height]);

      small_base_holder(holder_height, wall_thickness, startOffset);
    }

    translate([0, startOffset, 0]) {
      for(y=[0:1:row_count-1]) {
        translate([holder_width * x, holder_depth * y, 0]) {
          small_base_holder(
            holder_height, 
            wall_thickness,
            y == row_count - 1 ? holder_depth + endOffset : holder_depth);
        }
      }
    }

    translate([holder_width * x, 0, 0]) {
      translate([0, depth, 0]) {
        cube(size=[holder_width + wall_thickness, wall_thickness, holder_height]);
      }
    }
  }
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

    *translate([width * x, 0, 0]) {
      cube(size=[width + wall_thickness, wall_thickness, height]);
      
      translate([0, depth * row_count, 0]) {
        cube(size=[width + wall_thickness, wall_thickness, height]);
      }
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

compartmentWidth = smallBaseHolderWidth(inner_wall_thickness);
compartmentDepth = smallBaseHolderDepth(inner_wall_thickness) * rowCount;

box_compartment(
  width = compartmentWidth - inner_wall_thickness, 
  depth = compartmentDepth - inner_wall_thickness,
  height = 40,
  cornerSize = [10, 5]);

translate([0, 0, 0]) {
  small_base_holder_surface(compartmentWidth, compartmentDepth, inner_wall_thickness);
}

