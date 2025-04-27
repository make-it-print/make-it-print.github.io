use <Box Compartment.scad>
use <Math.scad>
use <Primitives.scad>

function getOffset(inner_wall_width) = (movementDialWidth() - (movementDialHoleWidth() + inner_wall_width * 2) )/2;
function movementDialWidth() = 53.5;
function movementDialDepth() = 8;
function movementDialHeight() = 8;
function movementDialHoleWidth() = 39;
function movementDialSeparatorWidth(inner_wall_width) = movementDialHoleWidth() / 2 - getOffset(inner_wall_width) + inner_wall_width;
function cutOutHeight() = 3;
reinforcementHeight = 0.4;
topReinforcementHeight = reinforcementHeight * 2;

module movement_dial_holder_separator_part(inner_wall_width = 1.6, connectorWidth, noLeftCutOut, noRightCutOut, position) {
  height = movementDialHeight();
  separatorWidth = movementDialSeparatorWidth(inner_wall_width);

  bottomCutOutHeight = cutOutHeight();
  topCutOutHeight = height - bottomCutOutHeight;
  if (noLeftCutOut) {
    cube(size=[separatorWidth / 2, inner_wall_width, height]);
  } else {
    translate([0, 0, bottomCutOutHeight]) {
      triangular_profile(topCutOutHeight, topCutOutHeight, inner_wall_width, [
        [0, 1],[1, 1], [1, 0]
      ]);
    }
      
    triangular_profile(topCutOutHeight, bottomCutOutHeight, inner_wall_width, [
      [0, 0],[1, 1], [1, 0]
    ]);
  }
    
  translate([topCutOutHeight, 0, 0]) {
    cube(size=[separatorWidth - topCutOutHeight * 2, inner_wall_width, height]);

    if (noRightCutOut) {
      cube(size=[separatorWidth - topCutOutHeight, inner_wall_width, height]);
    } else {
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
  }

  cube(size=[separatorWidth, inner_wall_width, reinforcementHeight]);
  translate([0, 0, height - topReinforcementHeight]) {
    cube(size=[separatorWidth, inner_wall_width, topReinforcementHeight]);
  }

  if (!is_undef(connectorWidth)) {
    offset = position == "left" ? separatorWidth - inner_wall_width : 0;
    translate([offset, inner_wall_width, 0]) {
      cube(size=[inner_wall_width, connectorWidth, height]);
      translate([0, connectorWidth, height])
      rotate(-90, [0, 0, 1]) {
        triangular_profile(connectorWidth + inner_wall_width, connectorWidth + inner_wall_width, inner_wall_width, [
          [0, 1],[1, 0], [0, 0]
        ]);
      }
    }
  }
}

module movement_dial_holder_separator(inner_wall_width = 1.6, connectorWidth, position) {
  width = movementDialWidth();
  hole_width = movementDialHoleWidth();
  offset = getOffset(inner_wall_width);

  translate([offset, 0, 0]) {
    movement_dial_holder_separator_part(
      inner_wall_width, connectorWidth, 
      position == "even" || position == "back" || position == "odd|left", 
      position == "odd" || position == "back" || position == "odd|left"  || position == "odd|right",
      "left");
  }

  translate([width - hole_width/2 - inner_wall_width, 0, 0]) {
    movement_dial_holder_separator_part(
      inner_wall_width, connectorWidth, 
      position == "odd" || position == "back" || position == "odd|left"  || position == "odd|right", 
      position == "even" || position == "back" || position == "odd|right",
      "right");
  }
}

module movement_dial_holder_side(inner_wall_width = 1.6, noCutOut) {
  depth = movementDialDepth();
  height = movementDialHeight();
  cutOutHeight = height;
  bottomCutOutHeight = cutOutHeight() + 1;
  topCutOutHeight = height - bottomCutOutHeight;
  cutOutDepth = 1.5;

  difference() {
    cube(size=[inner_wall_width, depth, height]);

    if (noCutOut == undef || noCutOut == false) {
      translate([inner_wall_width + 0.001, depth + 0.01, 0]) {
        rotate(90, [0, 0, 10]) {
          triangular_profile(cutOutDepth, bottomCutOutHeight + 0.001, inner_wall_width + 0.2, [
            [0, 0],[-1, 1], [0, 1]
          ]);
        }
  
        translate([0, 0, bottomCutOutHeight]) {
          rotate(90, [0, 0, 10]) {
            triangular_profile(cutOutDepth, topCutOutHeight, inner_wall_width + 0.2, [
              [-1, 0],[0, 0], [0, 1]
            ]);
          }
        }
      }
    }
  }

  cube(size=[inner_wall_width, depth, reinforcementHeight]);
  translate([0, 0, height - topReinforcementHeight]) {
    cube(size=[inner_wall_width, depth, topReinforcementHeight]);
  }
}

module movement_dial_holder_even(inner_wall_width = 1.6, connectorWidthLeft, connectorWidthRight) {
  union() {
    width = movementDialWidth();
    hole_width = movementDialHoleWidth();
    height = movementDialHeight();
  
    movement_dial_holder_separator(inner_wall_width, position = "even");
  
    offset = getOffset(inner_wall_width);
    noLeftCutOut = connectorWidthLeft != undef;
    noRightCutOut = connectorWidthRight != undef;
    connectorWidthLeft = is_undef(connectorWidthLeft) ? offset : connectorWidthLeft;
    connectorWidthRight = is_undef(connectorWidthRight) ? offset : connectorWidthRight;
  
    translate([offset - connectorWidthLeft, (depth + inner_wall_width) / 2, 0]) {
      cube(size=[connectorWidthLeft, inner_wall_width, height/2]);
    }
  
    translate([offset, inner_wall_width, 0]) {
      movement_dial_holder_side(inner_wall_width, noLeftCutOut);
        
      translate([hole_width + inner_wall_width, 0, 0]) {
        movement_dial_holder_side(inner_wall_width, noRightCutOut);
  
        translate([inner_wall_width, (depth - inner_wall_width) / 2, 0]) {
          cube(size=[connectorWidthRight, inner_wall_width, height/2]);
        }
      }
    }
  }
}

module movement_dial_holder_odd(inner_wall_width = 1.6, connectorWidth, connectorWidthLeft, connectorWidthRight) {
  union() {
    width = movementDialWidth();
    depth = movementDialDepth();
    height = movementDialHeight();
    hole_width = movementDialHoleWidth();
    
    position = connectorWidthLeft != undef ? 
      "odd|left" : 
      connectorWidthRight != undef ?
        "odd|right" :
        "odd";
  
    movement_dial_holder_separator(inner_wall_width, position = position);
    
    connectorWidth = is_undef(connectorWidth) ? hole_width - movementDialSeparatorWidth(inner_wall_width) * 2 + inner_wall_width * 4 : connectorWidth;
  
    translate([hole_width/2, inner_wall_width, 0]) {
    movement_dial_holder_side(inner_wall_width);
  
      translate([0, (depth - inner_wall_width) / 2, 0]) {
        cube(size=[connectorWidth, inner_wall_width, height/2]);
      }
    }
      
    translate([width - hole_width/2 - inner_wall_width, inner_wall_width, 0]) {
      movement_dial_holder_side(inner_wall_width);
    }
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
  height = movementDialHeight();
  offset = getOffset(inner_wall_width);
  
  movement_dial_row_depth = movementDialRowDepth(inner_wall_width);
  backWallOffset = movement_dial_row_depth * 2 + inner_wall_width * 2;
  row_count = movementDialRowCount(depth - backWallOffset, inner_wall_width);
  column_count = movementDialColumnCount(width);

  movement_dial_surface_depth = movementDialSurfaceDepth(row_count, inner_wall_width);
  movement_dial_surface_width = movementDialSurfaceWidth(column_count);
  
  movement_dial_surface_y_offset = depth - backWallOffset - movement_dial_surface_depth - inner_wall_width;
  movement_dial_surface_x_offset = (width - movement_dial_surface_width)/2;

  union () {
    *cube(size=[width, depth, 10]);
    
    translate([movement_dial_surface_x_offset, movement_dial_surface_y_offset, 0]) {
      *cube(size=[movement_dial_surface_width, movement_dial_surface_depth, 10]);
  
      for(x=[0:1:column_count - 1]) // repeat the following with two variants for x
      {
        for(i=[0:1:row_count - 1])
        {
          connectorWidthLeft = (x == 0) ? abs(movement_dial_surface_x_offset) + offset: undef;
          connectorWidthRight = (x == column_count - 1) ? abs(movement_dial_surface_x_offset) + offset : undef;
  
          translate([x * movement_dial_width, movement_dial_row_depth * i,0]) {
            if (i % 2 == 0) {
              movement_dial_holder_even(inner_wall_width, connectorWidthLeft, connectorWidthRight);
            } else {
              movement_dial_holder_odd(inner_wall_width, undef, connectorWidthLeft, connectorWidthRight);
            }
          }
        }
  
        translate([x * movement_dial_width, movement_dial_surface_depth, 0]) {
          movement_dial_holder_separator(inner_wall_width, backWallOffset, position = "back");
        }
      }
    }
  }
}

wall_thickness = 1.6;
inner_wall_width = 1;
depth = 8;
singleDial = true;
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