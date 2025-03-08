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

function wallMountedClickLockThickness(wall_thickness = 2) = wall_thickness * 1.5;

module wall_mounted_click_lock (fullDepth = 50, tongueDepth = 20, height = 10, wall_thickness = 2, tolerance = 0.1) {
  thickness = wallMountedClickLockThickness(wall_thickness);

  difference() {  
    wall_mount_base(fullDepth, height, thickness, 0) {
      cube(size=[thickness, fullDepth, wall_thickness * 2 + tolerance * 3]);

      translate([0, fullDepth, wall_thickness * 2 + tolerance * 3]) {
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

    negativeDepth = tongueDepth + wall_thickness;
    translate([-tolerance, -negativeDepth / 2, tolerance]) {
      cube(size=[tolerance * 4, negativeDepth, wall_thickness * 2]);
    }

    translate([tolerance, 0, tolerance]) {
      lid_mounted_click_lock_tongue(fullDepth = fullDepth, tongueDepth = negativeDepth, wall_thickness = wall_thickness + tolerance, tolerance = 0);
    }
  }
}

module lid_mounted_click_lock_tongue (fullDepth = 50, tongueDepth = 20, fingerNotchDepth = 20, wall_thickness = 2, tolerance = 0.1) {
  translate([-tolerance, -tongueDepth / 2, 0]) {
    difference() {
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
      
      translate([wall_thickness / 2, -wall_thickness, -tolerance]) {
        rotate(30, [0, 0, 1]) {
          cube(size=[wall_thickness * 2, wall_thickness, wall_thickness * 2 + tolerance * 2]);
        }
      }

      translate([wall_thickness / 2, tongueDepth + wall_thickness, wall_thickness * 2 + tolerance]) {
        rotate(180, [1, 0, 0]) {
          rotate(30, [0, 0, 1]) {
            cube(size=[wall_thickness * 2, wall_thickness, wall_thickness * 2 + tolerance * 2]);
          }
        }
      }
    }

    translate([-wall_thickness, 0, 0]) {
      cube(size=[wall_thickness, tongueDepth, wall_thickness * 2]);
    }

    // Diamond notch
    translate([0, tongueDepth / 2, 0]) {
      sideLength = (wall_thickness * 2) * sin(45);

      mirror(0, sideLength * 1.5, 0) {
        difference() {
          rotate(45, [1, 0, 0]) {
            cube(size=[wall_thickness, sideLength, sideLength]);
          }
          
          translate([0, -sideLength, 0]) {
            rotate(45, [0, 1, 0]) {
              cube(size=[sideLength, sideLength*2, sideLength*2]);
            }
          }
        }
      }
    }
  }

  fingerNotchWidth = wallMountedClickLockThickness(wall_thickness);
  clickLockOffset = fullDepth - tongueDepth + wall_thickness;
  translate([0, -(tongueDepth + clickLockOffset) / 2, 0]) {
    translate([0, tongueDepth + clickLockOffset, 0]) {
      lid_mounted_click_lock_tongue_finger_lip(fingerNotchDepth, wall_thickness);
    }

    translate([0, - fingerNotchDepth, 0]) {
      lid_mounted_click_lock_tongue_finger_lip(fingerNotchDepth, wall_thickness);;
    }
  }
}


module lid_mounted_click_lock_tongue_finger_lip (fingerNotchDepth = 20, wall_thickness = 2) {
  fingerNotchWidth = wallMountedClickLockThickness(wall_thickness);
  offset = fingerNotchWidth - wall_thickness;

  cube(size=[offset, fingerNotchDepth, wall_thickness]);
  
  translate([offset, 0, 0]) {
    triangular_profile(wall_thickness, wall_thickness, fingerNotchDepth, points=[
      [0, 1], [1, 1], [0, 0]
    ]);
  }
  translate([0, 0, wall_thickness]) {
    cube(size=[fingerNotchWidth, fingerNotchDepth, wall_thickness]);
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
tolerance = 0.1;
tongueDepth = 20;
fullDepth= 30;
fingerNotchDepth = 10;


// wall_mounted_stopper(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// wall_mounted_hinge(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// wall_mounted_hinge_tongue(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
//lid_mounted_click_lock_tongue_finger_lip (fingerNotchDepth, wall_thickness);

difference() {
  union() {
    //wall_mounted_click_lock(
    //  fullDepth = fullDepth, 
    //  tongueDepth=tongueDepth, 
    //  wall_thickness=wall_thickness, 
    //  tolerance=tolerance
    //);

    lid_mounted_click_lock_tongue(
      fullDepth = fullDepth, 
      tongueDepth=tongueDepth, 
      fingerNotchDepth = fingerNotchDepth, 
      wall_thickness=wall_thickness, 
      tolerance=tolerance
    );
  }
  
  //translate([-10, 0, -10]) {
  //  cube(size=[20, 50, 20]) ;
  //}
}

