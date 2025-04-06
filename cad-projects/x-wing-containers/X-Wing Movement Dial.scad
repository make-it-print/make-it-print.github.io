use <Box Compartment.scad>
use <Math.scad>
use <Primitives.scad>

function getOffset(inner_wall_width, width, hole_width) = (width - (hole_width + inner_wall_width * 2) )/2;
function movementDialWidth() = 54;
function movementDialDepth() = 8;
function movementDialHeight() = 8;
function movementDialHoleWidth() = 39;
function movementDialSeparatorWidth(hole_width, offset, inner_wall_width) = hole_width/2 - offset + inner_wall_width;
function cutOutHeight() = 3;

module movement_dial_holder_separator_part(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();
  offset = getOffset(inner_wall_width, width, hole_width);
  separatorWidth = movementDialSeparatorWidth(hole_width, offset, inner_wall_width);

  bottomCutOutHeight = cutOutHeight();
  topCutOutHeight = height - bottomCutOutHeight;
  translate([0, 0, bottomCutOutHeight]) {
    triangular_profile(topCutOutHeight, topCutOutHeight, inner_wall_width, [
      [0, 1],[1, 1], [1, 0]
    ]);
  }
    
  triangular_profile(topCutOutHeight, bottomCutOutHeight, inner_wall_width, [
    [0, 0],[1, 1], [1, 0]
  ]);
    
  translate([topCutOutHeight, 0, 0]) {
    cube(size=[separatorWidth - topCutOutHeight * 2, inner_wall_width, height]);

    translate([separatorWidth - topCutOutHeight * 2, 0, 0]) {
      translate([0, 0, bottomCutOutHeight]) {
        triangular_profile(topCutOutHeight, topCutOutHeight, inner_wall_width, [
          [0, 0],[0, 1], [1, 1]
        ]);
      }
      
      triangular_profile(topCutOutHeight, bottomCutOutHeight, inner_wall_width, [
        [0, 1],[1, 0], [0, 0]
      ]);
    }
  }

  cube(size=[separatorWidth, inner_wall_width, 0.4]);
  translate([0, 0, height - 0.4]) {
    cube(size=[separatorWidth, inner_wall_width, 0.4]);
  }
}

module movement_dial_holder_separator(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();
  offset = getOffset(inner_wall_width, width, hole_width);
  separatorWidth = movementDialSeparatorWidth(hole_width, offset, inner_wall_width);

  translate([offset, 0, 0]) {
    movement_dial_holder_separator_part(inner_wall_width);
  }

  translate([width - hole_width/2 - inner_wall_width, 0, 0]) {
    movement_dial_holder_separator_part(inner_wall_width);
  }
}

module movement_dial_holder_side(inner_wall_width = 1.6) {
  depth = movementDialDepth();
  height = movementDialHeight();
  cutOutHeight = height;
  bottomCutOutHeight = cutOutHeight();
  topCutOutHeight = height - bottomCutOutHeight;

  difference() {
    cube(size=[inner_wall_width, depth, height]);

    translate([inner_wall_width + 0.001, -0.001, 0]) {
      rotate(90, [0, 0, 10]) {
        triangular_profile(3, bottomCutOutHeight + 0.001, inner_wall_width + 0.2, [
          [0, 0],[1, 1], [0, 1]
        ]);
      }

      translate([0, 0, bottomCutOutHeight]) {
        rotate(90, [0, 0, 10]) {
          triangular_profile(3, topCutOutHeight, inner_wall_width + 0.2, [
            [0, 0],[1, 0], [0, 1]
          ]);
        }
      }
    }

    translate([inner_wall_width + 0.001, depth + 0.01, 0]) {
      rotate(90, [0, 0, 10]) {
        triangular_profile(3, bottomCutOutHeight + 0.001, inner_wall_width + 0.2, [
          [0, 0],[-1, 1], [0, 1]
        ]);
      }

      translate([0, 0, bottomCutOutHeight]) {
        rotate(90, [0, 0, 10]) {
          triangular_profile(3, topCutOutHeight, inner_wall_width + 0.2, [
            [-1, 0],[0, 0], [0, 1]
          ]);
        }
      }
    }
  }

  cube(size=[inner_wall_width, depth, 0.4]);
  translate([0, 0, height - 0.4]) {
    cube(size=[inner_wall_width, depth, 0.4]);
  }
}

module movement_dial_holder_even(inner_wall_width = 1.6) {
  width = movementDialWidth();
  hole_width = movementDialHoleWidth();

  movement_dial_holder_separator(inner_wall_width);

  offset = getOffset(inner_wall_width, width, hole_width);

  translate([offset, inner_wall_width, 0]) {
    movement_dial_holder_side(inner_wall_width);
    
      
    translate([hole_width + inner_wall_width, 0, 0]) {
      movement_dial_holder_side(inner_wall_width);
    }
  }
}

module movement_dial_holder_odd(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();

  movement_dial_holder_separator(inner_wall_width);

  offset = getOffset(inner_wall_width, width, hole_width);

  translate([hole_width/2, inner_wall_width, 0]) {
    movement_dial_holder_side(inner_wall_width);
  }
    
  translate([width - hole_width/2 - inner_wall_width, inner_wall_width, 0]) {
    movement_dial_holder_side(inner_wall_width);
  }
}

function movementDialRowDepth(inner_wall_width) = movementDialDepth() + inner_wall_width;
function movementDialRowCount(depth = 214, inner_wall_width) = floor((depth - inner_wall_width)/movementDialRowDepth(inner_wall_width));
function movementDialColumnCount(width = 214) = round( width / movementDialWidth());
function movementDialSurfaceDepth(row_count = 1, inner_wall_width) = row_count * movementDialRowDepth(inner_wall_width);
function movementDialSurfaceWidth(column_count = 1) = column_count * movementDialWidth();

module movement_dial_holder_surface(inner_wall_width, width = 214, depth = 214) {
  movement_dial_width = movementDialWidth();
  movement_dial_depth = movementDialDepth();
  
  movement_dial_row_depth = movementDialRowDepth(inner_wall_width);
  backWallOffset = movement_dial_row_depth * 2 + inner_wall_width * 2;
  row_count = movementDialRowCount(depth - backWallOffset, inner_wall_width);
  column_count = movementDialColumnCount(width);

  movement_dial_surface_depth = movementDialSurfaceDepth(row_count, inner_wall_width);
  movement_dial_surface_width = movementDialSurfaceWidth(column_count);
  
  movement_dial_surface_y_offset = depth - backWallOffset - movement_dial_surface_depth - inner_wall_width;
  movement_dial_surface_x_offset = (width - movement_dial_surface_width)/2;
  
  translate([movement_dial_surface_x_offset, movement_dial_surface_y_offset, 0]) {
    *cube(size=[movement_dial_surface_width, movement_dial_surface_depth, 10]);
    for(x=[0:1:column_count - 1]) // repeat the following with two variants for x
    {
      for(i=[0:1:row_count - 1])
      {
        translate([x * movement_dial_width, movement_dial_row_depth * i,0]) {
          if (i % 2 == 0) {
            movement_dial_holder_even(inner_wall_width);
          } else {
            movement_dial_holder_odd(inner_wall_width);
          }
        }
      }

      translate([x * movement_dial_width, movement_dial_surface_depth, 0]) {
        movement_dial_holder_separator(inner_wall_width);
      }
    }
  }
}

wall_thickness = 1.6;
inner_wall_width = 1;
depth = 8;
singleDial = false;
addWalls = true;
boxWidth = movementDialWidth() * 2 + inner_wall_width * 2;
boxDepth = movementDialDepth() * 6 + inner_wall_width * 2;
boxHeight = 40;

if (singleDial) {
  movement_dial_holder_even(inner_wall_width);
  
  translate([0, depth + inner_wall_width, 0]) {
    movement_dial_holder_odd(inner_wall_width);

     translate([0, depth + inner_wall_width, 0]) {
       movement_dial_holder_even(inner_wall_width);
     }
  }
} else {
  translate([0, 0, -0.8]) {
    cube(size=[boxWidth,boxDepth, 0.9]);
  }

  if (addWalls) {  
    extraWallWidth = 10;
    translate([boxWidth / 2 - extraWallWidth / 2, 0, 0]) {
      cube(size=[extraWallWidth, wall_thickness, boxHeight]);
  
      translate([0, boxDepth - wall_thickness, 0]) {
        cube(size=[extraWallWidth, wall_thickness, boxHeight]);
      }
    }
  
    translate([boxWidth / 4 - extraWallWidth / 2, 0, 0]) {
      translate([0, boxDepth - wall_thickness, 0]) {
        cube(size=[extraWallWidth, wall_thickness, boxHeight]);
      }
    }
  
    translate([boxWidth / 2 + boxWidth / 4 - extraWallWidth / 2, 0, 0]) {
      translate([0, boxDepth - wall_thickness, 0]) {
        cube(size=[extraWallWidth, wall_thickness, boxHeight]);
      }
    }
  
    box_compartment(
      width = boxWidth - wall_thickness * 2, 
      depth = boxDepth - wall_thickness * 2,
      height = boxHeight,
      cornerSize = [10, 5]);
  }
  
  movement_dial_holder_surface(inner_wall_width, boxWidth - wall_thickness, boxDepth - wall_thickness);
}