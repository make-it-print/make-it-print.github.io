use <Box.scad>
use <X-Wing Box Wall Mounts.scad>

clickLockTongueDepth = 30;
clickLockDepth = 50;
clickLockFingerLipDepth = 30;

module xwing_box_click_lock_tongue(wall_thickness) {
  lid_mounted_click_lock_tongue(fullDepth = clickLockDepth, tongueDepth = clickLockTongueDepth, fingerNotchDepth = clickLockFingerLipDepth, wall_thickness = wall_thickness, tolerance = 0);
}

module xwing_box_click_lock(wall_thickness) {
  wall_mounted_click_lock(fullDepth = clickLockDepth, tongueDepth = clickLockTongueDepth, wall_thickness = wall_thickness, tolerance = 0);
}

module xwing_box(width = 214, depth = 214, height = 60, radius = 5, wall_thickness = 2, inner_wall_thickness = 1.6) {
  box(wall_thickness, width, depth, height, radius) {
    xwing_box_click_lock_tongue(wall_thickness = wall_thickness);
    xwing_box_click_lock_tongue(wall_thickness = wall_thickness);
    xwing_box_click_lock(wall_thickness = wall_thickness);
    xwing_box_click_lock(wall_thickness = wall_thickness);
    double_wall_mount(width) {
      no_mounts();
      //wall_mounted_stopper(wall_thickness = wall_thickness, tolerance = 0);
    }
    double_wall_mount(width) {
      no_mounts();
      //wall_mounted_stopper(wall_thickness = wall_thickness, tolerance = 0);
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
  lid(wall_thickness, width, depth, radius) {
    xwing_box_click_lock_tongue(wall_thickness = wall_thickness);
    xwing_box_click_lock_tongue(wall_thickness = wall_thickness);
  }
}


xwing_box();

//translate([0, 0, 65]) {
//  xwing_box_lid();
//}