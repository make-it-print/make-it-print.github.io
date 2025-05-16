use <Box Compartment.scad>
use <Math.scad>
use <Primitives.scad>

function getOffset(inner_wall_width) = (movementDialWidth() - (movementDialHoleWidth() + inner_wall_width * 2) )/2;
function movementDialWidth() = 53.5;
function movementDialDepth() = 7;
function movementDialHeight() = 10;
function movementDialHoleWidth() = 43;
function movementDialSeparatorWidth(inner_wall_width) = movementDialHoleWidth() / 2 - getOffset(inner_wall_width) + inner_wall_width;
function cutOutHeight() = 3;
reinforcementHeight = 0.4;
topReinforcementHeight = reinforcementHeight * 2;
inclinationAngle = 25;

function movementDialDepthOffset() = (movementDialHeight() * sin(inclinationAngle)) / sin(90 - inclinationAngle);

module movement_dial_z_cut_planes() {
  translate([-50, -50, -50]) {
    cube(size=[100, 100, 50]);
  }

  height = movementDialHeight();
  translate([-50, -50, height]) {
    cube(size=[100, 100, 50]);
  }
}

LEFT = 0;
RIGHT = 1;
FRONT = 2;
BACK = 3;
ODD = 4;
LEFT_CONNECTOR = 5;
RIGHT_CONNECTOR = 6;
FRONT_CONNECTOR = 7;
BACK_CONNECTOR = 8;

function createDialProperties(isAtLeft, isAtRight, isAtFront, isAtBack, isOdd, leftConnector, rightConnector, fronConnector, backConnector) = [isAtLeft, isAtRight, isAtFront, isAtBack, isOdd, leftConnector, rightConnector, fronConnector, backConnector];

module movement_dial_holder_separator_part(inner_wall_width = 1.6, connectorWidth, position, dialHolderType, properties) {
  height = movementDialHeight();
  separatorWidth = movementDialSeparatorWidth(inner_wall_width);

  difference() {
    translate([0, inner_wall_width, 0]) {
      rotate(-inclinationAngle, [1, 0, 0]) {
        translate([0, -inner_wall_width, -height]) {
          cube(size=[separatorWidth, inner_wall_width, height * 3]);
        }
      }
    }
  
    movement_dial_z_cut_planes();

    noLeftCut = (position == "right" && dialHolderType == "odd|back") 
      || (position == "left" && dialHolderType == "even|back");

    if (!noLeftCut) {
      movement_dial_y_cut_planes();
    }

    noRightCut = (position == "left" && dialHolderType == "odd|back") 
      || (position == "right" && dialHolderType == "even|back");

    if (!noRightCut) {
      translate([separatorWidth, 0, 0]) {
        movement_dial_y_cut_planes(isRight = true);
      }
    }
  }

  if (properties[FRONT] == true) {
    difference() {
      translate([(separatorWidth - inner_wall_width) / 2, -properties[FRONT_CONNECTOR], 0]) {
        cube(size=[inner_wall_width, movementDialDepthOffset() + properties[FRONT_CONNECTOR], height / 2]);
      }
      
      translate([0, -movementDialDepth(), 0]) {
        movement_dial_x_cut_planes(front = false, back = true);
      }
    }
  }

  if (!is_undef(connectorWidth)) {
    if (dialHolderType == "even|back" || dialHolderType == "odd|back") {

      offset = position == "left" 
        ? dialHolderType == "odd|back" ? separatorWidth - inner_wall_width : 0
        : dialHolderType == "odd|back" ? 0 : separatorWidth - inner_wall_width;

      difference() {
        translate([offset, inner_wall_width + movementDialDepthOffset(), 0]) {
          translate([0, -movementDialDepthOffset() - inner_wall_width, 0]) {
            cube(size=[inner_wall_width, connectorWidth + inner_wall_width, height]);
          }
          
          translate([0, connectorWidth +  - movementDialDepthOffset(), height]) {
            rotate(-90, [0, 0, 1]) {
              triangular_profile(
                connectorWidth + inner_wall_width - movementDialDepthOffset(),
                connectorWidth + inner_wall_width - movementDialDepthOffset(),
                inner_wall_width, [
                [0, 1],[1, 0], [0, 0]
              ]);
            }
          }
        }

        movement_dial_x_cut_planes(front = true, back = false);
      }
    }
  }
}

module movement_dial_holder_separator(inner_wall_width = 1.6, connectorWidth, position, properties) {
  width = movementDialWidth();
  hole_width = movementDialHoleWidth();
  offset = getOffset(inner_wall_width);

  translate([offset, 0, 0]) {
    movement_dial_holder_separator_part(
      inner_wall_width, 
      connectorWidth, 
      "left",
      position, 
      properties = properties);
  }

  translate([width - hole_width/2 - inner_wall_width, 0, 0]) {
    movement_dial_holder_separator_part(
      inner_wall_width, 
      connectorWidth, 
      "right",
      position, 
      properties = properties);
  }
}

module movement_dial_x_cut_planes(front = true, back = true) {
  // Front
  if (front) {
    rotate(-inclinationAngle, [1, 0, 0]) {
      translate([-50, -50, -50]) {
        cube(size=[100, 50, 100]);
      }  
    }
  }
  
  // Back
  if (back) {
    depth = movementDialDepth();
    translate([0, depth, 0]) {
      rotate(-inclinationAngle, [1, 0, 0]) {
        translate([-50, 0, -50]) {
          cube(size=[100, 50, 100]);
        }  
      }
    }
  }
}


module movement_dial_y_cut_planes(isRight, isReverse) {
  height = movementDialHeight();
  translate([0, 0, height]) {
    if (isRight == true) {
      rotate(inclinationAngle, [0, 1, 0]) {
        offset = isReverse == true ? -50 : 0;
        translate([offset, -50, -50]) {
          cube(size=[50, 100, 100]);
        }  
      }
    } else {
      rotate(-inclinationAngle, [0, 1, 0]) {
        offset = isReverse == true ? 0 : -50;
        translate([offset, -50, -50]) {
          cube(size=[50, 100, 100]);
        }  
      }
    }
  }
}

module movement_dial_holder_side(inner_wall_width = 1.6, isReverse) {
  depth = movementDialDepth();
  height = movementDialHeight();
  cutOutHeight = height;
  bottomCutOutHeight = cutOutHeight() + 1;
  topCutOutHeight = height - bottomCutOutHeight;
  cutOutDepth = 1.5;

  angle = isReverse == true ? inclinationAngle : -inclinationAngle;
  xOffset = isReverse == true ? -inner_wall_width : 0;

  difference() {
    translate([xOffset * -1, 0, height]) {
      rotate(angle, [0, 1, 0]) {
        translate([xOffset, -depth, -height * 2]) {
          cube(size=[inner_wall_width, depth * 3, height * 3]);
        }
      }
    }
    
    movement_dial_z_cut_planes();
    movement_dial_x_cut_planes();
  }

}

module movement_dial_holder_even(inner_wall_width = 1.6, connectorWidthLeft, connectorWidthRight, addConnector, properties) {
  union() {
    width = movementDialWidth();
    hole_width = movementDialHoleWidth();
    height = movementDialHeight();
  
    movement_dial_holder_separator(inner_wall_width, position = "even", properties = properties);
  
    offset = getOffset(inner_wall_width);
    connectorWidthLeft = is_undef(connectorWidthLeft) ? offset : connectorWidthLeft;
    connectorWidthRight = is_undef(connectorWidthRight) ? offset : connectorWidthRight;
  
    if (addConnector != false) {
      difference() {
        translate([offset - connectorWidthLeft, (depth + inner_wall_width) / 2, 0]) {
          cube(size=[connectorWidthLeft + offset, inner_wall_width, height/2]);
        }
        
        translate([offset + inner_wall_width / 2, 0, 0]) {
          movement_dial_y_cut_planes(isReverse = true);
        }
      }
    }
    
  
    translate([offset, inner_wall_width, 0]) {
      movement_dial_holder_side(inner_wall_width);
        
      translate([hole_width + inner_wall_width, 0, 0]) {
        movement_dial_holder_side(inner_wall_width, isReverse = true);
   
        if (addConnector != false) {
          difference() {
            translate([inner_wall_width - hole_width, (depth - inner_wall_width) / 2, 0]) {
              cube(size=[connectorWidthRight + hole_width, inner_wall_width, height/2]);
            }
  
            movement_dial_y_cut_planes(isRight = true, isReverse = true);
          }
        }
      }
    }
  }
}

module movement_dial_holder_odd(inner_wall_width = 1.6, connectorWidthLeft, connectorWidthRight, addConnector, properties) {
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
  
    movement_dial_holder_separator(inner_wall_width, position = position, properties = properties);
    
    connectorWidth = hole_width - movementDialSeparatorWidth(inner_wall_width) * 2 + inner_wall_width * 4;
  
    translate([hole_width/2, inner_wall_width, 0]) {
      movement_dial_holder_side(inner_wall_width, isReverse = true);
    }
      
    translate([width - hole_width/2 - inner_wall_width, inner_wall_width, 0]) {
      movement_dial_holder_side(inner_wall_width);
    }

    if (addConnector != false) {
      difference() {
        translate([hole_width/2, inner_wall_width, 0]) {
          translate([-hole_width, (depth - inner_wall_width) / 2, 0]) {
            cube(size=[connectorWidth + hole_width * 2, inner_wall_width, height/2]);
          }
        }
  
        translate([hole_width/2, inner_wall_width, 0]) {
          movement_dial_y_cut_planes(isRight = true, isReverse = true);
        }
  
        translate([width - hole_width/2 - inner_wall_width * 0.5, inner_wall_width, 0]) {
          movement_dial_y_cut_planes(isReverse = true);
        }
      }
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
  backWallOffset = 28 - movementDialDepthOffset();
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
          connectorWidthLeft = (x == 0) ? abs(movement_dial_surface_x_offset) + offset : undef;
          connectorWidthRight = (x == column_count - 1) ? abs(movement_dial_surface_x_offset) + offset : undef;
  
          translate([x * movement_dial_width, movement_dial_row_depth * i,0]) {
            properties = createDialProperties(
              isAtLeft = x == 0,
              isAtRight = x == column_count - 1,
              isAtFront = i == 0,
              isAtBack = false,
              isOdd = i % 2 != 0,
              leftConnector = abs(movement_dial_surface_x_offset) + offset,
              rightConnector = abs(movement_dial_surface_x_offset) + offset,
              fronConnector = movement_dial_surface_y_offset,
              backConnector = backWallOffset);

            if (i % 2 == 0) {
              addConnector = i % 4 == 0;
              movement_dial_holder_even(inner_wall_width, connectorWidthLeft, connectorWidthRight, addConnector, properties = properties);
            } else {
              addConnector = i % 4 == 1;
              movement_dial_holder_odd(inner_wall_width, connectorWidthLeft, connectorWidthRight, addConnector, properties = properties);
            }
          }
        }
  
        translate([x * movement_dial_width, movement_dial_surface_depth, 0]) {
          position = row_count % 2 == 0 ? "even|back" : "odd|back";
          properties = createDialProperties(
              isAtLeft = x == 0,
              isAtRight = x == column_count - 1,
              isAtFront = false,
              isAtBack = true,
              isOdd = row_count % 2 != 0,
              leftConnector = abs(movement_dial_surface_x_offset) + offset,
              rightConnector = abs(movement_dial_surface_x_offset) + offset,
              fronConnector = movement_dial_surface_y_offset,
              backConnector = backWallOffset);
          movement_dial_holder_separator(inner_wall_width, backWallOffset, position = position, properties = properties);
        }
      }
    }
  }
}

wall_thickness = 1.6;
inner_wall_width = 1;
depth = 8;
singleDial = false;
addWalls = false;
boxWidth = movementDialWidth() * 2 + inner_wall_width * 2;
boxDepth = movementDialDepth() * 7 + inner_wall_width * 2;
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
  *translate([0, 0, -0.8]) {
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