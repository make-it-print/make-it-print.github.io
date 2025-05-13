use <Box Compartment.scad>

function smallBaseHolderWidth(wall_thickness = 1.6) = 41 + wall_thickness;
function smallBaseHolderDepth(wall_thickness = 1.6) = 9 + wall_thickness;

module small_base_holder(height = 8, wall_thickness = 1.6, depth, fullWidth) {
  width = smallBaseHolderWidth(wall_thickness);
  depth = is_undef(depth) ? smallBaseHolderDepth(wall_thickness) : depth;
  cornerWidth = 10;

  if (fullWidth == true) {
    cube(size=[width, wall_thickness, height / 2]);
  }

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

  row_count = floor((depth - wall_thickness - endOffset) / holder_depth);
  column_count = floor(width / holder_width);

  startOffset = depth - holder_depth * row_count - endOffset;

  *cube(size=[width, depth, 10]);
  
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
            y == row_count - 1 ? holder_depth + endOffset : holder_depth,
            y % 4 == 0);
        }
      }
    }

    translate([holder_width * x, 0, 0]) {
      translate([0, depth - wall_thickness, 0]) {
        cube(size=[holder_width + wall_thickness, wall_thickness, holder_height]);
      }
    }
  }
}

function largeBaseHolderSize() = 86;
function mediumBaseHolderSize() = 68;

function largeBaseHolderWidth(wall_thickness) = boxCompartmentOuterWidth(largeBaseHolderSize(), wall_thickness);
function largeBaseHolderDepth(wall_thickness) = boxCompartmentOuterDepth(largeBaseHolderSize(), wall_thickness);

module large_base_holder_compartment(width, depth, height = 40, wall_thickness = 1.6, base_height = 0, cornerSize) {
  width = is_undef(width) ? largeBaseHolderSize() : width;
  depth = is_undef(depth) ? largeBaseHolderSize() : depth;

  box_compartment(width, depth, height, wall_thickness, base_height = base_height, cornerSize = cornerSize);
}

module medium_base_holder_compartment(width, depth, height = 40, wall_thickness = 1.6, base_height = 0, cornerSize) {
  width = is_undef(width) ? mediumBaseHolderSize() : width;
  depth = is_undef(depth) ? mediumBaseHolderSize() : depth;

  box_compartment(width, depth, height, wall_thickness, base_height = base_height, cornerSize = cornerSize);
}

translate([0, 0, -10]) {
  %cube(size=[220-6,220-6, 10]);
}

inner_wall_thickness = 1.6;
rowCount = 6;

compartmentWidth = smallBaseHolderWidth(inner_wall_thickness) + inner_wall_thickness;
compartmentDepth = smallBaseHolderDepth(inner_wall_thickness) * rowCount + inner_wall_thickness;

box_compartment(
  width = compartmentWidth - inner_wall_thickness * 2, 
  depth = compartmentDepth - inner_wall_thickness * 2,
  height = 40,
  cornerSize = [10, 5]);

*cube(size=[compartmentWidth, compartmentDepth, 10]);
translate([0, 0, 0]) {
  small_base_holder_surface(compartmentWidth, compartmentDepth, inner_wall_thickness);
}

