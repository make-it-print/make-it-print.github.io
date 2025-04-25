include <Box Properties.scad>
use <Box.scad>
use <X-Wing Box Wall Mounts.scad>

clickLockTongueDepth = 30 - 2*3;
clickLockFingerLipDepth = 30;

module xwing_box_click_lock_tongue(wall_thickness) {
  wall_mounted_snap_lock_tongue(tongueDepth = clickLockTongueDepth, fingerLipDepth = clickLockFingerLipDepth, wall_thickness = wall_thickness, tolerance = 0.1);
}

module xwing_box_click_lock(wall_thickness) {
  wall_mounted_snap_lock(tongueDepth = clickLockTongueDepth, wall_thickness = wall_thickness, tolerance = 0.1);
}

module nothing() {}

module xwing_box(boxProperties) {
  box(boxProperties) {
    nothing();
    nothing();
    xwing_box_click_lock_tongue(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock_tongue(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock(wall_thickness = boxProperties[WallThickness]);
  }

  if ($children > 0) {
    difference() {
      union() {
        translate([boxProperties[WallThickness], boxProperties[WallThickness], boxProperties[WallThickness]]) {
          for(i=[0:$children-1])
            children(i);  
        }
      }

      if (!$preview)
        boxOuterWallClipShape(boxProperties);
    }
  }
}


module xwing_box_lid(boxProperties) {
  lid(boxProperties) {
    xwing_box_click_lock_tongue(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock_tongue(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock_tongue(wall_thickness = boxProperties[WallThickness]);
    xwing_box_click_lock_tongue(wall_thickness = boxProperties[WallThickness]);
  }
}

showBox = false;
showLid = false;
showInsert = true;

boxProperties = createBoxProperties(width = 214, depth = 214, height = 60, radius = 5, wall_thickness = 2);

if (showBox) {
  xwing_box(boxProperties);
}

if (showLid) {
  translate([0, 0, 65]) {
    xwing_box_lid(boxProperties);
  }
}

if (showInsert) {
  insertProperties = mutateBoxProperties(boxProperties, tolerance = 0.3);
  box_insert(insertProperties);
}