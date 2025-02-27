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
    wall_mount_base(fullDepth, height, wall_thickness, tolerance) {
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

module lid_mounted_hinge (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.1) {
  translate([-tolerance, -depth / 2, 0]) {
      cube(size=[wall_thickness + tolerance, depth, wall_thickness]);
  }
}

module wall_mounted_buckle_anchor_notch (height = 10, wall_thickness = 2) {
  thickness = wall_thickness * 2;
  translate([0, 0, 0]) {
    linear_extrude(height=height) {
      polygon(points=[[0,0],[0, wall_thickness],[wall_thickness, 0]], paths=[[0,1,2]]);
    }  
  }

  translate([thickness / 2, 0, 0]) {
    linear_extrude(height=height) {
      polygon(points=[[0,0],[wall_thickness, wall_thickness],[wall_thickness, 0]], paths=[[0,1,2]]);
    }
  }
}


module wall_mounted_buckle_anchor (depth = 6, height = 6, wall_thickness = 2, tolerance = 0.1) {
  thickness = wall_thickness * 2;
  anchorBodyDepth = depth - wall_thickness * 2;

  difference() {
    union() {
      translate([0, wall_thickness, 0]) {
        cube(size=[thickness, anchorBodyDepth, height]);  
      }
    
      translate([0, anchorBodyDepth + wall_thickness, 0]) {
        !wall_mounted_buckle_anchor_notch(height, wall_thickness);
      }
    
      translate([thickness, wall_thickness, 0]) {
        rotate(180, [0, 0, 1]) {
          wall_mounted_buckle_anchor_notch(height, wall_thickness);
        }
      }
    }
  
    translate([0, anchorBodyDepth + wall_thickness * 2 + tolerance, -tolerance]) {
      rotate(90, [1, 0, 0]) {
        linear_extrude(height=depth + (wall_thickness + tolerance) * 2) {
          polygon(points=[[thickness + tolerance,-tolerance],[-tolerance, -tolerance],[thickness + tolerance, thickness + tolerance]], paths=[[0,1,2]]);
        }  
      }
    } 
  }
}

module buckle (depth = 6, height = 6, wall_thickness = 2, tolerance = 0.1) {
  thickness = wall_thickness * 2;
  buckleDepth = depth + wall_thickness * 2;

  difference() {
    translate([0, -wall_thickness, -wall_thickness]) {
      cube(size=[thickness, buckleDepth, height * 2 + wall_thickness * 2]);
    }

    translate([-tolerance, -tolerance, 0]) {
      wall_mounted_buckle_anchor(depth + tolerance, height + tolerance, wall_thickness + tolerance, tolerance);
    }

    translate([-tolerance, 0, height]) {
      cube(size=[thickness + tolerance * 2, depth, height]);
    }
  }
}

wall_thickness = 2;
tolerance = 0.1;
depth = 20;

// !wall_mounted_stopper(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// wall_mounted_hinge(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
// lid_mounted_hinge(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);
wall_mounted_buckle_anchor(wall_thickness=wall_thickness, tolerance=tolerance);
// buckle(wall_thickness=wall_thickness, tolerance=tolerance);
