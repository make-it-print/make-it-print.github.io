module box_base_shape(width = 220, depth = 220, height=50, top_radius=10, bottom_radius=8) {
  $fn = $preview ? 16 : 64;

  hull() {
    for (x=[radius, width - top_radius]) {
      for (y=[radius, depth - top_radius]) {
        translate([x, y, 0]) {
          cylinder(r1 = bottom_radius, r2 = top_radius, h = height);  
        }
      }
    }
  }
}

module box_walls(width = 220, depth = 220, height=50, radius=10, chamfer_radius=8, negative=false) {
  union() {
    chamfer_size = radius - chamfer_radius;
    negative_tolerance = 0.01;

    if (negative) {
      translate([0, 0, - wall_width]) {
        box_base_shape(width - chamfer_size, depth - chamfer_size, wall_width*2, chamfer_radius, chamfer_radius);
      }
    }

    // Bottom with chamfer
    box_base_shape(width, depth, wall_width, radius, chamfer_radius);

    translate([0, 0, wall_width-negative_tolerance]) {
      // Walls
      box_base_shape(width, depth, height - wall_width + negative_tolerance*2, radius, radius);

      if (negative) {
        translate([0, 0, height - wall_width - 0.1]) {
          box_base_shape(width, depth, wall_width, radius, radius);
        }
      }
    }
  }
}

module box_base(wall_width = 2, width = 220, depth = 220, height=50, radius=10, tolerance=0.2, lid = false) {
  translate([0, 0, -wall_width]) {
    union() {
      chamfer_size = wall_width + tolerance;
      chamfer_radius = radius - chamfer_size;
      
      // Bottom
      if (lid) {
        difference() {
          box_base_shape(width - chamfer_size, depth - chamfer_size, wall_width, chamfer_radius, chamfer_radius);
          translate([0,0,-0.2]) {
            box_base_shape(width - chamfer_size*2, depth - chamfer_size*2, wall_width+0.4, chamfer_radius - wall_width, chamfer_radius - wall_width);
          }
        }
      } else {
        box_base_shape(width - chamfer_size, depth - chamfer_size, wall_width, chamfer_radius, chamfer_radius);
      }
      
      translate([0, 0, wall_width]) {
        if (lid) {
            box_base_shape(width, depth, wall_width, radius, radius);
        } else {
          difference() {
            box_walls(width, depth, height, radius, chamfer_radius);
            box_walls(width - wall_width, depth - wall_width, height, radius - wall_width, chamfer_radius - wall_width, negative=true);
          }
        }
      }
    }
  }
}

module box(wall_width = 2, width = 220, depth = 220, height=45, radius=10, tolerance=0.4) {
  box_base(wall_width, width, depth, height, radius, tolerance, false);
}

module lid(wall_width = 2, width = 220, depth = 220, radius=10, tolerance=0.2) {
  box_base(wall_width, width, depth, wall_width * 2, radius, tolerance, true);
}


wall_width = 2;
inner_wall_width = 1.6;
width = 50;
depth = 50;
height = 10;
radius = 5;
tolerance = 0.2;

box(wall_width, width, depth, height, radius, tolerance);
// lid(wall_width, width, depth, radius, tolerance);

translate([0, 0, height + wall_width/2]) {
  lid(wall_width, width, depth, radius, tolerance);
  // box(wall_width, width, depth, height, radius, tolerance);
}