function getOffset(inner_wall_width, width, hole_width) = (width - (hole_width + inner_wall_width * 2) )/2;
function movementDialWidth() = 54;
function movementDialDepth() = 8;
function movementDialHeight() = 8;
function movementDialHoleWidth() = 37;

module movement_dial_holder_separator(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();

  offset = getOffset(inner_wall_width, width, hole_width);

  translate([offset, 0, 0]) {
    cube(size=[hole_width/2 - offset + inner_wall_width, inner_wall_width, height]);
  }

  translate([width - hole_width/2 - inner_wall_width, 0, 0]) {
    cube(size=[hole_width/2 - offset + inner_wall_width, inner_wall_width, height]);
  }
}

module movement_dial_holder_even(inner_wall_width = 1.6) {
  width = movementDialWidth();
  depth = movementDialDepth();
  height = movementDialHeight();
  hole_width = movementDialHoleWidth();

  movement_dial_holder_separator(inner_wall_width);

  offset = getOffset(inner_wall_width, width, hole_width);

  translate([offset, inner_wall_width, 0]) {
    cube(size=[inner_wall_width, depth, height]);
  
    translate([hole_width + inner_wall_width, 0, 0]) {
      cube(size=[inner_wall_width, depth, height]);
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
    cube(size=[inner_wall_width, depth, height]);
  }

  translate([width - hole_width/2 - inner_wall_width, inner_wall_width, 0]) {
    cube(size=[inner_wall_width, depth, height]);
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
  row_count = movementDialRowCount(depth, inner_wall_width);
  column_count = movementDialColumnCount(width);

  movement_dial_surface_depth = movementDialSurfaceDepth(row_count, inner_wall_width);
  movement_dial_surface_width = movementDialSurfaceWidth(column_count);
  
  movement_dial_surface_y_offset = (depth - (movement_dial_surface_depth + inner_wall_width))/2;
  movement_dial_surface_x_offset = (width - movement_dial_surface_width)/2;
  
  translate([movement_dial_surface_x_offset, movement_dial_surface_y_offset, 0]) {  
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
singleDial = true;

if (singleDial) {
  %movement_dial_holder_even(inner_wall_width);
  
  translate([0, depth + inner_wall_width, 0]) {
    %movement_dial_holder_odd(inner_wall_width);
  }
} else {
  translate([0, 0, -10]) {
    %cube(size=[220,220, 10]);
  }
  
  movement_dial_holder_surface();
}