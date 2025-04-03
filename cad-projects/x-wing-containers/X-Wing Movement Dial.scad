use <Box Compartment.scad>
use <Math.scad>

function getOffset(inner_wall_width, width, hole_width) = (width - (hole_width + inner_wall_width * 2) )/2;
function movementDialWidth() = 54;
function movementDialDepth() = 8;
function movementDialHeight() = 8;
function movementDialHoleWidth() = 39;
function movementDialSeparatorWidth(hole_width, offset, inner_wall_width) = hole_width/2 - offset + inner_wall_width;

module movement_dial_holder_separator(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();
  offset = getOffset(inner_wall_width, width, hole_width);
  separatorWidth = movementDialSeparatorWidth(hole_width, offset, inner_wall_width);

  translate([offset, 0, 0]) {
    cube(size=[separatorWidth, inner_wall_width, height]);
  }

  translate([width - hole_width/2 - inner_wall_width, 0, 0]) {
    cube(size=[separatorWidth, inner_wall_width, height]);
  }
}

module movement_dial_holder_cut_box(angle) {
  height = movementDialHeight();

  rotate(90, angle) {
    rotate(0, [0, 0, 1]) {
      cube(size=[height, height, height*2], center=true);
    }
  }
}

module movement_dial_holder_cut_outs(inner_wall_width, even = true) {
  height = movementDialHeight();
  width = movementDialWidth();
  hole_width = movementDialHoleWidth();
  offset = getOffset(inner_wall_width, width, hole_width);
  separatorWidth = movementDialSeparatorWidth(hole_width, offset, inner_wall_width);

  depthOffset1 = even ? depth + inner_wall_width * 2 : inner_wall_width;
  depthOffset2 = even ? inner_wall_width : depth + inner_wall_width * 2;

  translate([offset, 0, 0]) {
    translate([0, depthOffset1, 0]) {
      translate([0, 0, 0]) {
        movement_dial_holder_cut_box([1, 1, 0]);
      }
    
      translate([hole_width + inner_wall_width * 2, 0, 0]) {
        movement_dial_holder_cut_box([-1, 1, 0]);
      }
    }

    translate([0, depthOffset2, 0]) {
      translate([separatorWidth, 0, 0]) {
        movement_dial_holder_cut_box([-1, 1, 0]);

        if (even)
          translate([0, 0, 0])
            movement_dial_holder_cut_box([-1, 1, 0]);
      }
    
      translate([hole_width + inner_wall_width * 2 - separatorWidth, 0, 0]) {
        movement_dial_holder_cut_box([1, 1, 0]);
      }
    }
  }
}

module movement_dial_holder_even(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();

  difference() {
    union() {
      movement_dial_holder_separator(inner_wall_width);

      offset = getOffset(inner_wall_width, width, hole_width);

      translate([offset, inner_wall_width, 0]) {
        cube(size=[inner_wall_width, depth, height]);
      
        translate([hole_width + inner_wall_width, 0, 0]) {
          cube(size=[inner_wall_width, depth, height]);
        }
      }
    }

    movement_dial_holder_cut_outs(inner_wall_width);
  }
}

module movement_dial_holder_odd(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();

  difference() {
    union() {
      movement_dial_holder_separator(inner_wall_width);

      offset = getOffset(inner_wall_width, width, hole_width);

      translate([hole_width/2, inner_wall_width, 0]) {
        cube(size=[inner_wall_width, depth, height]);
      }
    
      translate([width - hole_width/2 - inner_wall_width, inner_wall_width, 0]) {
        cube(size=[inner_wall_width, depth, height]);
      }
    }

    movement_dial_holder_cut_outs(inner_wall_width, false);
  }
}

function movementDialRowDepth(inner_wall_width = 1.6) = movementDialDepth() + inner_wall_width;
function movementDialRowCount(depth = 214, inner_wall_width = 1.6) = floor((depth - inner_wall_width)/movementDialRowDepth());
function movementDialColumnCount(width = 214) = round( width / movementDialWidth());
function movementDialSurfaceDepth(row_count = 1, inner_wall_width = 1.6) = row_count * movementDialRowDepth(inner_wall_width);
function movementDialSurfaceWidth(column_count = 1) = column_count * movementDialWidth();

module movement_dial_holder_surface(inner_wall_width = 1.6, width = 214, depth = 214) {
  movement_dial_width = movementDialWidth();
  movement_dial_depth = movementDialDepth();
  
  movement_dial_row_depth = movementDialRowDepth(inner_wall_width);
  backWallOffset = movement_dial_row_depth * 2 + inner_wall_width;
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

inner_wall_width = 1.6;
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
      cube(size=[extraWallWidth, inner_wall_width, boxHeight]);
  
      translate([0, boxDepth - inner_wall_width, 0]) {
        cube(size=[extraWallWidth, inner_wall_width, boxHeight]);
      }
    }
  
    translate([boxWidth / 4 - extraWallWidth / 2, 0, 0]) {
      translate([0, boxDepth - inner_wall_width, 0]) {
        cube(size=[extraWallWidth, inner_wall_width, boxHeight]);
      }
    }
  
    translate([boxWidth / 2 + boxWidth / 4 - extraWallWidth / 2, 0, 0]) {
      translate([0, boxDepth - inner_wall_width, 0]) {
        cube(size=[extraWallWidth, inner_wall_width, boxHeight]);
      }
    }
  
    box_compartment(
      width = boxWidth - inner_wall_width * 2, 
      depth = boxDepth - inner_wall_width * 2,
      height = boxHeight,
      cornerSize = [10, 5]);
  }
  
  movement_dial_holder_surface(inner_wall_width, boxWidth, boxDepth);
}