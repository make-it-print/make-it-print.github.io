use <Box.scad>
use <X-Wing Box Wall Mounts.scad>

module xwing_box(width = 214, depth = 214, height = 60, radius = 5, wall_thickness = 2, inner_wall_thickness = 1.6) {
  box(wall_thickness, width, depth, height, radius) {
    lid_mounted_click_lock_tongue(wall_thickness = wall_thickness, tolerance = 0);
    lid_mounted_click_lock_tongue(wall_thickness = wall_thickness, tolerance = 0);
    wall_mounted_click_lock(wall_thickness = wall_thickness, tolerance = 0);
    wall_mounted_click_lock(wall_thickness = wall_thickness, tolerance = 0);
    double_wall_mount(width) {
      wall_mounted_stopper(wall_thickness = wall_thickness, tolerance = 0);
    }
    double_wall_mount(width) {
      wall_mounted_stopper(wall_thickness = wall_thickness, tolerance = 0);
    }
  }

  if ($children > 0) {
    translate([wall_thickness, wall_thickness, wall_thickness]) {
      for(i=[0:$children-1])
        children(i);  
    }
  }
}


module xwing_box_lid(width = 214, depth = 214, height = 60, radius = 5, wall_thickness = 2, inner_wall_thickness = 1.6) {
  translate([0, 0, height + wall_thickness  + 10]) {
    lid(wall_thickness, width, depth, radius) {
      lid_mounted_click_lock_tongue(wall_thickness = wall_thickness, tolerance = 0);
      lid_mounted_click_lock_tongue(wall_thickness = wall_thickness, tolerance = 0);
    }
  }
}


xwing_box();