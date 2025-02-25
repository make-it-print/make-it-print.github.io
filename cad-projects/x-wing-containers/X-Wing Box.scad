use <X-Wing Box Slide Clamp.scad>
use <X-Wing Box Wall Mounts.scad>

module place_wall_mounts_x(box_width, box_depth, depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2)
{
  translate([0, box_depth / 2, 0]) {
    rotate(180, [0, 0, 1]) {
      children(0);
    }

    translate([box_width, 0, 0]) {
      children(0);
    }
  }
}

module place_wall_mounts_y(box_width, box_depth, depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2)
{
  translate([box_width / 2, 0, 0]) {
    rotate(-90, [0, 0, 1]) {
      children(0);
    }

    translate([0, box_depth, 0]) {
      rotate(90, [0, 0, 1]) {
        children(0);
      }
    }
  }
}

module box_base_shape(width, depth, height, top_radius, bottom_radius) {
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


module box_base(wall_width = 2, width = 220, depth = 220, height=50, radius=10, tolerance=0.2, lid = false) {
  union() {
    // Bottom
    box_base_shape(width, depth, wall_width, radius, radius);
      
    // Walls
    translate([0, 0, wall_width]) {
      if (!lid) {
        difference() {
          box_base_shape(width, depth, height, radius, radius);
          translate([0, 0, -wall_width]) {
            box_base_shape(
              width - wall_width, 
              depth - wall_width, 
              height + wall_width * 2, 
              radius - wall_width, 
              radius - wall_width);
          }
        }
      }
    }
  }
}

module box(wall_width = 2, width = 220, depth = 220, height=45, radius=10, tolerance=0.2) {
  difference() {
    box_base(wall_width, width, depth, height, radius, tolerance, false);
    
    translate([0, 0, height + wall_width]) {
      place_wall_mounts_x(box_width = width, box_depth = depth, wall_thickness = wall_width, tolerance = tolerance) {
        wall_mount_hole(wall_thickness = wall_width, tolerance = tolerance);
      }
    }
  }

  translate([0, 0, height + wall_width]) {
    place_wall_mounts_y(box_width = width, box_depth = depth, wall_thickness = wall_width, tolerance = tolerance) {
      wall_mounted_stopper(wall_thickness = wall_width, tolerance = tolerance);
    }
  }

  place_wall_mounts_x(box_width = width, box_depth = depth, wall_thickness = wall_width, tolerance = tolerance) {
    base_mounted_clip_holder(wall_thickness = wall_width, tolerance = tolerance);
  }
}

module lid(wall_width = 2, width = 220, depth = 220, radius=10, tolerance=0.2) {
  box_base(wall_width, width, depth, wall_width * 2, radius, tolerance, true);

  place_wall_mounts_x(box_width = width, box_depth = depth, wall_thickness = wall_width, tolerance = tolerance) {
    base_mounted_clip_holder(wall_thickness = wall_width, tolerance = tolerance);
  }
}


module box_clip_holders(wall_width = 2, width = 220, depth = 220, height=45, radius=10, tolerance=0.2) {
  translate([0, 0, height + wall_width]) {
    place_wall_mounts_x(box_width = width, box_depth = depth, wall_thickness = wall_width, tolerance = tolerance) {
      wall_mounted_clip_holder(wall_thickness = wall_width, tolerance = tolerance);
    }
  }
}


wall_width = 2;
inner_wall_width = 1.6;
width = 40;
depth = 40;
height = 15;
radius = 5;
tolerance = 0.2;

box(wall_width, width, depth, height, radius, tolerance);

wallMountsOffset = 10;

translate([-wallMountsOffset, 0, 0]) {
  box_clip_holders(wall_width, width + wallMountsOffset*2, depth, height, radius, tolerance);  
}

translate([-wallMountsOffset * 2 - wall_width, depth / 2, height + wall_width]) {
  clip(wall_thickness=wall_width);
}

// lid(wall_width, width, depth, radius, tolerance);

translate([0, 0, height + wall_width * 3]) {
  lid(wall_width, width, depth, radius, tolerance);
  // box(wall_width, width, depth, height, radius, tolerance);
}