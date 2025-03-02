module wall_mount_base (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2) {
  translate([0, -depth / 2, 0]) {
    baseThickness = wall_thickness + tolerance * 2;
    baseHeight = wall_thickness * 2;
    
    union() {
      translate([-tolerance, 0, 0]) {
        rotate(-90, [1, 0, 0]) {
          linear_extrude(height=depth) {
              polygon(points=[[0,0],[0, baseHeight],[baseThickness, 0]], paths=[[0,1,2]]);
          }
        }
      }

      translate([tolerance, 0, 0]) {
        for(i=[0:$children-1])
          children(i); // do each of the shapes that come after us
      }
    }
  }
}


module wall_mounted_stopper (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2) {
  wall_mount_base(depth, height, wall_thickness, tolerance) {
    cube(size=[wall_thickness, depth, wall_thickness]);
  }
}

module wall_mounted_hinge (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.1) {
  fullDepth = depth + wall_thickness * 2;

  difference() {  
    wall_mount_base(fullDepth, height, wall_thickness, 0) {
      cube(size=[wall_thickness, wall_thickness, wall_thickness + tolerance]);
  
      translate([0, fullDepth - wall_thickness, 0]) {
        cube(size=[wall_thickness, wall_thickness, wall_thickness + tolerance]);
      }
      
      translate([0, 0, wall_thickness + tolerance]) {
        cube(size=[wall_thickness, fullDepth, wall_thickness]);
      }
    }
  
    translate([0, -depth / 2, 0]) {
      rotate(30, [0, 1, 0]) {
        cube(size=[wall_thickness * 3, depth, wall_thickness]);
      }
    }
  }
}

module wall_mounted_hinge_tongue (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.1) {
  translate([-tolerance, -depth / 2, 0]) {
    cube(size=[wall_thickness + tolerance, depth, wall_thickness]);
  }
}


module wall_mounted_click_lock (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.1) {
  fullDepth = depth + wall_thickness * 6;
  thickness = wall_thickness * 1.5;

  difference() {  
    wall_mount_base(fullDepth, height, thickness, 0) {
      cube(size=[thickness, fullDepth, wall_thickness * 2]);

      translate([0, fullDepth, wall_thickness * 2]) {
        rotate(90, [1, 0, 0]) {
          linear_extrude(height=fullDepth) {
            polygon(
              points=[
                [thickness / 2, thickness / 2], // right
                [thickness, 0], // left
                [0, 0] // top
              ], 
              paths=[[0,1,2]]
            );
          }
        }
      }
    }

    negativeDepth = depth + wall_thickness;
    translate([-tolerance, -negativeDepth / 2, 0]) {
      cube(size=[tolerance * 4, negativeDepth, wall_thickness * 2]);
    }

    translate([tolerance * 2, 0, 0]) {
      lid_mounted_click_lock_tongue(depth = negativeDepth, wall_thickness = wall_thickness, tolerance = 0);
    }
  }
}

module lid_mounted_click_lock_tongue (depth = 20, wall_thickness = 2, tolerance = 0.1) {
  translate([-tolerance, -depth / 2, 0]) {
    difference() {
      translate([0, 0, wall_thickness * 2]) {
        rotate(-90, [1, 0, 0]) {
          linear_extrude(height=depth) {
            polygon(
              points=[
                [0,0],
                [0, wall_thickness * 2],
                [wall_thickness, wall_thickness]
              ], 
              paths=[[0,1,2]]
            );
          }
        }
      }
      
      translate([wall_thickness / 2, -wall_thickness, -tolerance]) {
        rotate(30, [0, 0, 1]) {
          cube(size=[wall_thickness * 2, wall_thickness, wall_thickness * 2 + tolerance * 2]);
        }
      }

      translate([wall_thickness / 2, depth+wall_thickness, wall_thickness * 2 + tolerance]) {
        rotate(180, [1, 0, 0]) {
          rotate(30, [0, 0, 1]) {
            cube(size=[wall_thickness * 2, wall_thickness, wall_thickness * 2 + tolerance * 2]);
          }
        }
      }
    }

    translate([-wall_thickness, 0, 0]) {
      cube(size=[wall_thickness, depth, wall_thickness * 2]);
    }
  }

  clickLockOffset = wall_thickness * 7;
  fingerNotchDepth = wall_thickness * 5;
  translate([0, -(depth + clickLockOffset) / 2, 0]) {
    translate([0, depth + clickLockOffset, 0]) {
      cube(size=[wall_thickness, fingerNotchDepth, wall_thickness]);
    }

    translate([0, - fingerNotchDepth, 0]) {
      cube(size=[wall_thickness, fingerNotchDepth, wall_thickness]);
    }
  }
}



wall_thickness = 2;
tolerance = 0.1;
depth = 20;

// wall_mounted_stopper(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// wall_mounted_hinge(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// wall_mounted_hinge_tongue(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);

wall_mounted_click_lock(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
*lid_mounted_click_lock_tongue(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);

