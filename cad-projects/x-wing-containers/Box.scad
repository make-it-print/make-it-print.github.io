use <X-Wing Box Slide Clamp.scad>
use <X-Wing Box Wall Mounts.scad>

module place_wall_mounts_x(box_width, box_depth)
{
  translate([0, box_depth / 2, 0]) {
    rotate(180, [0, 0, 1]) {
      children(0);
    }

    translate([box_width, 0, 0]) {
        children(1);
    }
  }
}

module place_wall_mounts_y(box_width, box_depth)
{
  translate([box_width / 2, 0, 0]) {
    rotate(-90, [0, 0, 1]) {
      children(0);
    }

    translate([0, box_depth, 0]) {
      rotate(90, [0, 0, 1]) {
          children(1);
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

module box_walls(wall_width = 2, width = 220, depth = 220, height=50, top_radius=10, bottom_radius=10) {
  difference() {
    box_base_shape(width, depth, height, top_radius, bottom_radius);
    translate([0, 0, -wall_width]) {
      box_base_shape(
        width - wall_width, 
        depth - wall_width, 
        height + wall_width * 2, 
        top_radius - wall_width, 
        bottom_radius - wall_width);
    }
  }
}

module box_base(wall_width = 2, width = 220, depth = 220, height=50, radius=10, lid = false) {
  union() {
    // Bottom
    box_base_shape(width, depth, wall_width, radius, radius);
      
    // Walls
    translate([0, 0, wall_width]) {
      if (!lid) {
        box_walls(wall_width, width, depth, height, radius, radius);
      }
    }
  }
}

module wall_reinforcement(wall_width = 2, width = 220, depth = 220, height=45, radius=10) {
  reinforcementHeight = 6;
  reinforcementWidth = width + wall_width;
  reinforcementDepth = depth + wall_width;
  reinforcementRadius = radius + wall_width;
  translate([0, 0, -reinforcementHeight]) {
    box_walls(wall_width, reinforcementWidth, reinforcementDepth, reinforcementHeight, reinforcementRadius, radius);
    translate([0, 0, reinforcementHeight]) {
      difference() {
        box_walls(wall_width, reinforcementWidth, reinforcementDepth, wall_width, reinforcementRadius, reinforcementRadius);
        translate([-wall_width, reinforcementRadius * 2, 0]) {
          cube(size=[reinforcementWidth + wall_width * 2, reinforcementDepth - reinforcementRadius * 4, 10]);
        }
      }
    }
  }
}

module box(wall_width = 2, width = 220, depth = 220, height=45, radius=10) {
  box_base(wall_width, width, depth, height, radius, false);
 
  if ($children > 0) {
    // base mounts
    place_wall_mounts_x(box_width = width, box_depth = depth) {
      children(0);
      children(1);
    }
    
    translate([0, 0, height + wall_width]) {
      wall_reinforcement(wall_width, width, depth, height, radius);
      place_wall_mounts_x(box_width = width, box_depth = depth) {
        children(2);
        children(3);
      }
    }
  
    translate([0, 0, height + wall_width]) {
      place_wall_mounts_y(box_width = width, box_depth = depth) {
        children(4);
        children(5);
      }
    }
  }
}

module lid(wall_width = 2, width = 220, depth = 220, radius=10) {
  box_base(wall_width, width, depth, wall_width * 2, radius, true);

  if ($children > 0) {
    place_wall_mounts_x(box_width = width, box_depth = depth) {
      children(0);
      if ($children > 1)
        children(1);
    }
  }
}


wall_width = 2;
inner_wall_width = 1.6;
width = 50;
depth = 75;
height = 10;
radius = 5;
tolerance = 0.2;

prod = true;
showBox = true;
showLid = false;

if (prod) {
  width = 220 - 6;
  depth = 220 - 6;
  height = 60;

  if (showBox)
    box(wall_width, width, depth, height, radius) {
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      wall_mounted_click_lock(wall_thickness = wall_width, tolerance = 0);
      wall_mounted_click_lock(wall_thickness = wall_width, tolerance = 0);
      double_wall_mount(width) {
        wall_mounted_stopper(wall_thickness = wall_width, tolerance = 0);
      }
      double_wall_mount(width) {
        wall_mounted_stopper(wall_thickness = wall_width, tolerance = 0);
      }
    }

    //translate([0, 0, wall_width]) {
    //  box_walls(wall_width, width, depth, 10, radius, radius + wall_width);
    //}
  
  if (showLid)
    translate([0, 0, height + wall_width  + 10]) {
      lid(wall_width, width, depth, radius, tolerance) {
        lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
        lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      }
    }
} else {
  box(wall_width, width, depth, height, radius, tolerance) {
    lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
    lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
    wall_mounted_click_lock(wall_thickness = wall_width, tolerance = 0);
    wall_mounted_click_lock(wall_thickness = wall_width, tolerance = 0);
    wall_mounted_stopper(wall_thickness = wall_width, tolerance = 0);
    wall_mounted_stopper(wall_thickness = wall_width, tolerance = 0);
  }
  
  translate([0, 0, height + wall_width  + 10]) {
    lid(wall_width, width, depth, radius, tolerance) {
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
    }
  }
}
