module clip_wall_mount (depth = 10, height = 10, wall_thickness = 2, tolerance = 0.1) {
  translate([0, -depth / 2, 0]) {
    // wall
    translate([0, 0, -height]) {
      cube(size=[wall_thickness, depth, height]);
    }
    
    translate([wall_thickness, 0, 0]) {
      // hanger
      translate([0, 0, -wall_thickness]) {
        cube(size=[wall_thickness + tolerance, depth, wall_thickness]);
      }
    
      translate([tolerance, 0, 0]) {
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
  }
}

module clip_hanger(depth = 10, height = 10, wall_thickness = 2, tolerance = 0.1) {
  translate([0, -depth / 2, 0]) {
    translate([0, 0, - wall_thickness * 2 - tolerance * 1.5]) {
      translate([0, depth, 0]) {
        rotate(90, [1, 0, 0]) {
          linear_extrude(height=depth) {
              polygon(points=[[0, 0],[0, wall_thickness],[wall_thickness,0]], paths=[[0,1,2]]);
          }
        }
      }

      translate([0, 0, - wall_thickness]) {
        cube(size=[wall_thickness + tolerance, depth, wall_thickness]);
      }
    }
  }
}

module clip(depth = 10, height = 10, wall_thickness = 2, tolerance = 0.1) {
  translate([0, -depth / 2, 0]) {
    full_height = wall_thickness * 6 + tolerance * 3;

    translate([wall_thickness + tolerance, 0, - full_height / 2]) {
      cube(size=[wall_thickness, depth, full_height]);
    }
  }

  clip_hanger(depth, height, wall_thickness, tolerance);

  rotate(180, [1, 0, 0]) {
    clip_hanger(depth, height, wall_thickness, tolerance);
  }
}

assembled = true;

wall_thickness = 2;
tolerance = 0.1;
depth = 10;

if (assembled) {
  clip_wall_mount(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
  
  translate([0, 0, 0]) {
    rotate(180, [1, 0, 0]) {
      clip_wall_mount(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
    }  
  }
  
  translate([wall_thickness + tolerance, 0, 0]) {
    clip(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
  }
} else {
  rotate(-90, [0, 1, 0]) {
    clip_wall_mount(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);  
  }

  translate([0, depth * 1.5, wall_thickness * 2 + tolerance]) {
    rotate(90, [0, 1, 0]) {
      clip(tolerance=tolerance, wall_thickness=wall_thickness, depth=depth);
    }  
  }
}

