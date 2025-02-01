function getOffset(inner_wall_width, width, hole_width) = (width - (hole_width + inner_wall_width * 2) )/2;

module movement_dial_holder_separator(inner_wall_width = 1.6, width = 54, depth = 8, height = 8, hole_width = 40) {
  offset = getOffset(inner_wall_width, width, hole_width);

  translate([offset, 0, 0]) {
    cube(size=[hole_width/2 - offset + inner_wall_width, inner_wall_width, height]);
  }

  translate([width - hole_width/2 - inner_wall_width, 0, 0]) {
    cube(size=[hole_width/2 - offset + inner_wall_width, inner_wall_width, height]);
  }
}

module movement_dial_holder_angled_walls(inner_wall_width = 1.6, width = 54, depth = 8, height = 8, hole_width = 40, rowIndex = 0) {
  offset = getOffset(inner_wall_width, width, hole_width);

  angle = 12;
  a = hole_width/2 - offset + inner_wall_width;
  h = a / cos(angle);
  b = sin(angle) * h;
  wall_center = inner_wall_width / 2;
  spacer_width = 2;
  spacer_offset = wall_center + spacer_width / 2;
  wall_offset = b / 2 + wall_center;

  translate([offset + a / 2, wall_offset, height / 2]) {
    direction = 1;

    if (rowIndex % 2 == 0) {
      direction = -1;
    }

    rotate(angle * direction, [0, 0, 1]) {
      cube(size=[h, inner_wall_width, height], center = true);
    }

    translate([a + offset * 2, 0, 0]) {
      rotate(-angle * direction, [0, 0, 1]) {
        cube(size=[h, inner_wall_width, height], center = true);
      }  
    }
  }
}

module movement_dial_holder_angled_even(inner_wall_width = 1.6, width = 54, depth = 8, height = 8, hole_width = 40) {
  offset = getOffset(inner_wall_width, width, hole_width);

  angle = 12;
  a = hole_width/2 - offset + inner_wall_width;
  h = a / cos(angle);
  b = sin(angle) * h;
  wall_center = inner_wall_width / 2;
  spacer_width = 2;
  spacer_offset = wall_center + spacer_width / 2;
  wall_offset = b / 2 + wall_center;

  for (i=[0:2]) {
    translate([0, (b + spacer_offset * 2) * i, 0]) {
      translate([offset + a / 2, wall_offset, height / 2]) {
        if (i % 2 == 0) {
          rotate(-angle, [0, 0, 1]) {
            cube(size=[h, inner_wall_width, height], center = true);
          }

          translate([a + offset * 2, 0, 0]) {
            rotate(angle, [0, 0, 1]) {
              cube(size=[h, inner_wall_width, height], center = true);
            }  
          }
        } else {
          rotate(angle, [0, 0, 1]) {
            cube(size=[h, inner_wall_width, height], center = true);
          }

          translate([a + offset * 2, 0, 0]) {
            rotate(-angle, [0, 0, 1]) {
              cube(size=[h, inner_wall_width, height], center = true);
            }  
          }
        }
      }
    
      if (i % 2 == 0) {
        translate([offset + wall_center, b + wall_center + spacer_offset, 0]) {
          cube(size=[inner_wall_width, spacer_width + inner_wall_width * 2, height], center = true);

          translate([hole_width + inner_wall_width, 0, 0]) {
              cube(size=[inner_wall_width, spacer_width + inner_wall_width * 2, height], center = true);
          }
        }
      } else {
        translate([offset - wall_center + a, b + wall_center + spacer_offset, 0]) {
          cube(size=[inner_wall_width, spacer_width + inner_wall_width * 2, height], center = true);

          translate([offset * 2 + inner_wall_width, 0, 0]) {
            cube(size=[inner_wall_width, spacer_width + inner_wall_width * 2, height], center = true);
          }
        }
      }
    }
  }
}

module movement_dial_holder_even(inner_wall_width = 1.6, width = 54, depth = 8, height = 8, hole_width = 40) {
  movement_dial_holder_separator(inner_wall_width, width, depth, height, hole_width);

  offset = getOffset(inner_wall_width, width, hole_width);

  translate([offset, inner_wall_width, 0]) {
    cube(size=[inner_wall_width, depth, height]);
  
    translate([hole_width + inner_wall_width, 0, 0]) {
      cube(size=[inner_wall_width, depth, height]);
    }
  }
}

module movement_dial_holder_odd(inner_wall_width = 1.6, width = 54, depth = 8, height = 8, hole_width = 40) {
  movement_dial_holder_separator(inner_wall_width, width, depth, height, hole_width);

  offset = getOffset(inner_wall_width, width, hole_width);

  translate([hole_width/2, inner_wall_width, 0]) {
    cube(size=[inner_wall_width, depth, height]);
  }

  translate([width - hole_width/2 - inner_wall_width, inner_wall_width, 0]) {
    cube(size=[inner_wall_width, depth, height]);
  }
}

module movement_dial_holder_v1(inner_wall_width = 1.6, width = 54, depth = 8, height = 8, hole_width = 40) {
  cube(size=[width, inner_wall_width, height]);

  offset = (width - (hole_width + inner_wall_width * 2) )/2;
  translate([offset, inner_wall_width, 0]) {
    cube(size=[inner_wall_width, depth, height]);
  
    translate([hole_width + inner_wall_width, 0, 0]) {
      cube(size=[inner_wall_width, depth, height]);
    }
  }
}

module movement_dial_holder_odd_v1(inner_wall_width = 1.6, width = 54, depth = 8, height = 8, hole_width = 40) {
  cube(size=[width, inner_wall_width, height]);

  translate([hole_width/2, inner_wall_width, 0]) {
    cube(size=[inner_wall_width, depth, height]);
  }

  translate([width - hole_width/2 - inner_wall_width, inner_wall_width, 0]) {
      cube(size=[inner_wall_width, depth, height]);
    }
}

inner_wall_width = 1.6;
width = 54;
depth = 8;
height = 8;
hole_width = 40;

%movement_dial_holder_even(inner_wall_width, width, depth, height, hole_width);

translate([0, depth + inner_wall_width, 0]) {
  %movement_dial_holder_odd(inner_wall_width, width, depth, height, hole_width);
}

!movement_dial_holder_angled_even(inner_wall_width, width, depth, height, hole_width);