module clip_holder(depth = 20, wall_thickness = 2, tolerance = 0.2) {
    // hanger
    translate([0, 0, -wall_thickness]) {
      cube(size=[wall_thickness * 1.5, depth, wall_thickness]);
    }
  
    translate([wall_thickness * 0.5, 0, 0]) {
      // clip
      translate([0, 0, -wall_thickness*2]) {
        translate([0, depth, 0]) {
          rotate(90, [1, 0, 0]) {
            linear_extrude(height=depth) {
                polygon(points=[[wall_thickness,0],[0, wall_thickness],[wall_thickness,wall_thickness]], paths=[[0,1,2]]);
            }
          }
        }
      }
    }
}

module clip_holder_mount_notches(depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2) {
  union() {
    // right
    translate([wall_thickness, 0, -height / 2]) {
      rotate(45, [0, 0, 1]) {
        cube(size=[wall_thickness + tolerance, wall_thickness + tolerance, height + 0.2], center=true);
      }
    }

    // left
    translate([wall_thickness, depth, -height / 2]) {
      rotate(45, [0, 0, 1]) {
        cube(size=[wall_thickness + tolerance, wall_thickness + tolerance, height + 0.2], center=true);
      }
    }

    // bottom
    translate([wall_thickness, depth / 2, -height]) {
      rotate(45, [0, 1, 0]) {
        cube(size=[wall_thickness + tolerance, depth + 0.2, wall_thickness + tolerance], center=true);
      }
    }
  }
}


module clip_holder_mount(depth = 20, height = 10, wall_thickness = 2) {
  translate([0, 0, -height]) {
    cube(size=[(wall_thickness + wall_thickness), depth, height]);
  }
}

module wall_mounted_clip_holder (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2) {
  translate([-wall_thickness * 1.5, -depth / 2, 0]) {
    difference() {
      union() {
        clip_holder_mount(depth, height, wall_thickness);
        translate([wall_thickness * 2, 0, 0]) {
          clip_holder(depth, wall_thickness, tolerance);
        }
      }

      clip_holder_mount_notches(depth, height, wall_thickness, tolerance);
    }
  }
}

module base_mounted_clip_holder (depth = 20, wall_thickness = 2, tolerance = 0.2) {
  translate([-wall_thickness * 1.5, depth / 2, 0]) {
    rotate(180, [1, 0, 0]) {
      union() {
        clip_holder_mount(depth, wall_thickness, wall_thickness);
        translate([wall_thickness * 2, 0, 0]) {
          clip_holder(depth, wall_thickness, tolerance);
        }
      }  
    }
  }
}

module wall_mount_hole (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2) {

  translate([-wall_thickness * 1.5, -depth / 2, tolerance]) {
    difference() {
      union() {
        clip_holder_mount(depth, height + tolerance, wall_thickness);
      }

      clip_holder_mount_notches(depth, height, wall_thickness, 0);
    }
  }
}


module clip(depth = 10, height = 10, wall_thickness = 2, tolerance = 0.2) {
  full_height = wall_thickness * 6 + tolerance * 4;
 
  translate([0, -depth/2, -full_height / 2]) {
    cube(size=[wall_thickness, depth, full_height]);
  
    translate([wall_thickness/2 + tolerance, 0, 0]) {
      translate([0, 0, full_height]) {
        clip_holder(depth, wall_thickness, tolerance);
      }

      translate([wall_thickness * 1.5, 0, 0]) {
        cube(size=[wall_thickness / 2 - tolerance, depth, wall_thickness * 2]); 
      }

      translate([wall_thickness * 1.5, 0, full_height - wall_thickness * 2]) {
        cube(size=[wall_thickness / 2 - tolerance, depth, wall_thickness * 2]); 
      }
    
      translate([0, depth, 0]) {
        rotate(180, [1, 0, 0]) {
          clip_holder(depth,  wall_thickness, tolerance);
        }
      }
    }
  }
}


assembled = false;
rotationAngle = 0;

wall_thickness = 2;
tolerance = 0.2;
depth = 20;

// !clip(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
// !clip_holder_mount(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// !wall_mounted_clip_holder(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// !wall_mount_hole(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
!base_mounted_clip_holder(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);

if (assembled) {
  wall_mounted_clip_holder(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
  
  translate([0, 0, 0]) {
    rotate(180, [1, 0, 0]) {
      wall_mounted_clip_holder(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
    }
  }
  
  translate([wall_thickness * 4.5 + tolerance, 0, 0]) {
    rotate(180, [0, 1, 0]) {
      clip(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
    }
  }
} else {
  rotate(-1 * rotationAngle, [0, 1, 0]) {
    wall_mounted_clip_holder(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);  
  }

  translate([0, depth * 1.5, wall_thickness * 2 + tolerance]) {
    rotate(rotationAngle, [0, 1, 0]) {
      clip(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
    }  
  }
}

