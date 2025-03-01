module wall_mounted_buckle_anchor_notch (height = 10, wall_thickness = 2, tolerance=0.1) {
  thickness = wall_thickness * 2;
      
  linear_extrude(height=height) {
    polygon(
      points=[
        [0,0],
        [thickness, thickness],
        [thickness, 0]
      ], 
      paths=[[0,1,2]]
    );
  }  
}

module wall_mounted_buckle_anchor (depth = 10, height = 6, wall_thickness = 2, tolerance = 0.1, negative=false) {
  thickness = wall_thickness * 2;
  anchorBodyDepth = depth - wall_thickness * 2;

  difference() {
    hull() {
      translate([0, depth - thickness - tolerance, 0]) {
        wall_mounted_buckle_anchor_notch(height, wall_thickness, tolerance);
      }

      translate([0, thickness + tolerance, height]) {
        rotate(180, [1, 0, 0]) {
          wall_mounted_buckle_anchor_notch(height, wall_thickness, tolerance);
        }  
      }     
    }
  
    if (!negative) {
      negativeOffset = 0.05;
      translate([0, anchorBodyDepth + wall_thickness * 2 + negativeOffset, -negativeOffset]) {
        rotate(90, [1, 0, 0]) {
          linear_extrude(height=depth + (wall_thickness + negativeOffset) * 2) {
            polygon(points=[
                [thickness + negativeOffset,-negativeOffset], // (1,0)
                [-negativeOffset - tolerance, -negativeOffset], // (0,0)
                [thickness + negativeOffset, thickness + negativeOffset + tolerance] // (1,1)
              ], 
              paths=[[0,1,2]]);
          }  
        }
      } 
    }
  }
}


module buckle (depth = 10, height = 6, wall_thickness = 2, tolerance = 0.1) {
  thickness = wall_thickness * 2;
  buckleDepth = depth + wall_thickness * 2;

  difference() {
    translate([0, -wall_thickness, -wall_thickness]) {
      cube(size=[thickness, buckleDepth, height * 2 + wall_thickness * 2]);
    }

    translate([-tolerance/2, -tolerance/2, 0]) {
      wall_mounted_buckle_anchor(depth + tolerance, height + tolerance, wall_thickness + tolerance/2, 0, true);
    }

    translate([-tolerance, 0, height]) {
      cube(size=[thickness + tolerance * 2, depth, height]);
    }
  }
}

wall_thickness = 2;
tolerance = 0.1;
depth = 20;

translate([-2, -5, -7]) {
  cube(size=[2, 20, 20]);
}
wall_mounted_buckle_anchor(wall_thickness=wall_thickness, tolerance=tolerance);
 buckle(wall_thickness=wall_thickness, tolerance=tolerance);