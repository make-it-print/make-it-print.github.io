use <Alignments.scad>
use <Primitives.scad>

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

module no_mounts() {}

module wall_mounted_stopper (depth = 32, height = 10, wall_thickness = 2, tolerance = 0.2) {
  wall_mount_base(depth, height, wall_thickness, tolerance) {
    cube(size=[wall_thickness, depth, wall_thickness]);
  }
}

module wall_mounted_hinge (tongueDepth = 30, height = 10, wall_thickness = 2, tolerance = 0.1) {
  sideDepth = wall_thickness * 3;
  fullDepth = tongueDepth + (sideDepth + tolerance) * 2;

  thickness = wallMountedClickLockThickness(wall_thickness);

  difference() {  
    side_fixture_body (fullDepth, height, wall_thickness, tolerance);

    negativeDepth = tongueDepth + tolerance * 2;
    translate([-tolerance, -negativeDepth / 2, tolerance]) {
      cube(size=[thickness + tolerance * 2, negativeDepth, thickness]);
    }
  }
}

module wall_mounted_hinge_tongue (depth = 30, height = 10, wall_thickness = 2, tolerance = 0.1) {
  thickness = wallMountedClickLockThickness(wall_thickness);
  halfThickness = thickness / 2;

  module negative(depth = 30, height = 10, wall_thickness = 2) {
    translate([0, -depth/2, -height]) {
      rotate(-60, [0, 0, 1]) {
        cube(size=[thickness * 2, wall_thickness * 3, height * 2]);
      }
    }
  }

  difference() {
    translate([-tolerance, -depth / 2, 0]) {
      cube(size=[halfThickness, depth, halfThickness]);
  
      translate([halfThickness, 0, 0]) {
        triangular_profile(halfThickness, halfThickness, depth, points=[
          [0, 1], [1, 1], [0, 0]
        ]);
      }
  
      translate([0, 0, halfThickness]) {
        cube(size=[thickness, depth, halfThickness]);
      }
    }

    negative(depth, height, wall_thickness);
    rotate(180, [1, 0, 0]) {
      negative(depth, height, wall_thickness);
    }
  }
}

function wallMountedSnapLockWidth(tongueDepth = 30, wall_thickness = 2, tolerance = 0.1) = tongueDepth + (wall_thickness * 6 + tolerance) * 2;

module wall_mounted_snap_lock (tongueDepth = 30, wall_thickness = 2, tolerance = 0.1) {
  height = 10;
  fullDepth = wallMountedSnapLockWidth(tongueDepth = tongueDepth, wall_thickness = wall_thickness, tolerance = tolerance);

  thickness = wallMountedClickLockThickness(wall_thickness);

  difference() {  
    side_fixture_body (fullDepth, height, wall_thickness, tolerance);

    translate([-tolerance, 0, 0]) {
      wall_mounted_hinge_lock_tongue_triangle(thickness + tolerance * 2, tongueDepth + tolerance * 4);
    }
  }
}

module wall_mounted_hinge_lock_tongue_triangle (width, depth, tolerance = 0) {
  translate([0, depth / 2, 0]) {
    rotate(-90, [0, 0, 1]) {
      triangular_profile(depth + tolerance, depth + tolerance, width + tolerance);
    }
  }
}

module wall_mounted_snap_lock_tongue (tongueDepth = 30, fingerLipDepth = 20, wall_thickness = 2, tolerance = 0.1) {
  thickness = wallMountedClickLockThickness(wall_thickness);
  halfThickness = thickness / 2;
  
  difference() {
    translate([-tolerance, 0, 0]) {
      wall_mounted_hinge_lock_tongue_triangle(thickness + tolerance, tongueDepth);
    }

    translate([-thickness / 2, -tongueDepth, wall_thickness * 2]) {
      cube(size=[thickness * 2, tongueDepth * 2, tongueDepth]);
    }

    translate([thickness - wall_thickness, 0, 0]) {
      rotate(-45, [0, 1, 0]) {
        translate([0, -tongueDepth, -wall_thickness]) {
          cube(size=[thickness * 2, tongueDepth * 2, wall_thickness]);
        }
      }
    }
  }

  fullDepth = wallMountedSnapLockWidth(tongueDepth = tongueDepth, wall_thickness = wall_thickness, tolerance = tolerance);

  if (fingerLipDepth > 0) {
    fingerNotchWidth = wallMountedClickLockThickness(wall_thickness);
    clickLockOffset = fullDepth - tongueDepth + wall_thickness;
    translate([0, -(tongueDepth + clickLockOffset) / 2, 0]) {
      translate([0, tongueDepth + clickLockOffset, 0]) {
        lid_mounted_click_lock_tongue_finger_lip(fingerLipDepth, wall_thickness);
      }
  
      translate([0, - fingerLipDepth, 0]) {
        lid_mounted_click_lock_tongue_finger_lip(fingerLipDepth, wall_thickness);
      }
    }
  }
}

function wallMountedClickLockThickness(wall_thickness = 2) = wall_thickness * 1.5;

module side_fixture_body (fullDepth = 50, height = 10, wall_thickness = 2, tolerance = 0.1) {
  thickness = wallMountedClickLockThickness(wall_thickness);

  wall_mount_base(fullDepth, height, thickness, 0) {
    cube(size=[thickness, fullDepth, wall_thickness * 2 + tolerance * 3]);

    translate([0, 0, wall_thickness * 2 + tolerance * 3]) {
      triangular_profile(thickness, thickness, fullDepth, points=[
        [0.5, 0.5], [1, 0], [0, 0]
      ]);

      translate([thickness / 2, 0, 0])
        cube(size=[thickness / 2, fullDepth, thickness / 2]);
    }
  }
}

module wall_mounted_click_lock (fullDepth = 50, tongueDepth = 30, height = 10, wall_thickness = 2, tolerance = 0.1) {
  thickness = wallMountedClickLockThickness(wall_thickness);

  difference() {  
    side_fixture_body (fullDepth, height, wall_thickness, tolerance);

    negativeDepth = tongueDepth + wall_thickness;
    translate([-tolerance, -negativeDepth / 2, tolerance]) {
      cube(size=[tolerance * 4, negativeDepth, wall_thickness * 2]);
    }

    translate([tolerance, 0, tolerance]) {
      lid_mounted_click_lock_tongue(fullDepth = fullDepth, tongueDepth = negativeDepth, wall_thickness = wall_thickness + tolerance, tolerance = 0);
    }
  }
}

module lid_mounted_click_lock_tongue (fullDepth = 50, tongueDepth = 30, fingerLipDepth = 20, wall_thickness = 2, tolerance = 0.1) {
  translate([-tolerance, -tongueDepth / 2, 0]) {
    difference() {
      // Main triangular body
      translate([0, 0, wall_thickness * 2]) {
        rotate(-90, [1, 0, 0]) {
          linear_extrude(height=tongueDepth) {
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
      
      // Side cut
      translate([wall_thickness / 2, -wall_thickness, -tolerance]) {
        rotate(30, [0, 0, 1]) {
          cube(size=[wall_thickness * 2, wall_thickness, wall_thickness * 2 + tolerance * 2]);
        }
      }

      // Side cut
      translate([wall_thickness / 2, tongueDepth + wall_thickness, wall_thickness * 2 + tolerance]) {
        rotate(180, [1, 0, 0]) {
          rotate(30, [0, 0, 1]) {
            cube(size=[wall_thickness * 2, wall_thickness, wall_thickness * 2 + tolerance * 2]);
          }
        }
      }
    }

    // Base
    translate([-wall_thickness, 0, 0]) {
      cube(size=[wall_thickness, tongueDepth, wall_thickness * 2]);
    }

    // Tongue claws
    translate([0, tongueDepth / 2, 0]) {
      sideLength = (wall_thickness * 2) * sin(45);

      mirror(0, sideLength * 1.5, 0) {
        lid_mounted_click_lock_tongue_claw(wall_thickness);
      }
    }
  }

  if (fingerLipDepth > 0) {
    fingerNotchWidth = wallMountedClickLockThickness(wall_thickness);
    clickLockOffset = fullDepth - tongueDepth + wall_thickness;
    translate([0, -(tongueDepth + clickLockOffset) / 2, 0]) {
      translate([0, tongueDepth + clickLockOffset, 0]) {
        lid_mounted_click_lock_tongue_finger_lip(fingerLipDepth, wall_thickness);
      }
  
      translate([0, - fingerLipDepth, 0]) {
        lid_mounted_click_lock_tongue_finger_lip(fingerLipDepth, wall_thickness);
      }
    }
  }
}

module lid_mounted_click_lock_tongue_claw (wall_thickness = 2) {
  size = wall_thickness * 2;
  sideLength = size * sin(45);
  centerSize = wall_thickness / 2;
  
  difference() {
    union() {
      mirror(0, centerSize / 2, 0) {
        rotate(45, [1, 0, 0]) {
          cube(size=[wall_thickness, sideLength, sideLength]);
        }
      }
      
      center(0, centerSize, 0) {
        cube(size=[wall_thickness, centerSize, size]);
      }
    }
    
    translate([0, -sideLength, 0]) {
      rotate(45, [0, 1, 0]) {
        cube(size=[sideLength, sideLength*2, sideLength*2]);
      }
    }
  }
}


module lid_mounted_click_lock_tongue_finger_lip (fingerLipDepth = 20, wall_thickness = 2) {
  fingerNotchWidth = wallMountedClickLockThickness(wall_thickness);
  offset = fingerNotchWidth - wall_thickness;

  cube(size=[offset, fingerLipDepth, wall_thickness]);
  
  translate([offset, 0, 0]) {
    triangular_profile(wall_thickness, wall_thickness, fingerLipDepth, points=[
      [0, 1], [1, 1], [0, 0]
    ]);
  }
  translate([0, 0, wall_thickness]) {
    cube(size=[fingerNotchWidth, fingerLipDepth, wall_thickness]);
  }
}


module double_wall_mount(width) {
  offset = width / 5;

  translate([0, offset, 0]) {
    children(0);
  }

  translate([0, -offset, 0]) {
    children(0);
  }
}



wall_thickness = 2;
tolerance = 0;
tongueDepth = 30;
fullDepth= 30;
fingerLipDepth = 10;


// wall_mounted_stopper(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
//wall_mounted_hinge(wall_thickness=wall_thickness);
//wall_mounted_hinge_tongue(wall_thickness=wall_thickness);
//lid_mounted_click_lock_tongue_finger_lip (fingerLipDepth, wall_thickness);
// lid_mounted_click_lock_tongue_claw();
wall_mounted_snap_lock(wall_thickness=wall_thickness);
wall_mounted_snap_lock_tongue(wall_thickness=wall_thickness);

/*
difference() {
  union() {
    wall_mounted_click_lock(
      fullDepth = fullDepth, 
      tongueDepth=tongueDepth, 
      wall_thickness=wall_thickness, 
      tolerance=tolerance
    );

    //lid_mounted_click_lock_tongue(
    //  fullDepth = fullDepth, 
    //  tongueDepth=tongueDepth, 
    //  fingerLipDepth = fingerLipDepth, 
    //  wall_thickness=wall_thickness, 
    //  tolerance=tolerance
    //);
  }
  
  //translate([-10, 4.5, -10]) {
  //  cube(size=[20, 50, 20]) ;
  //}
}
*/
