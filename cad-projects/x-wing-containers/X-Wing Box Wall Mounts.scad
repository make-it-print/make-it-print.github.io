module wall_mounted_stopper (depth = 20, height = 10, wall_thickness = 2, tolerance = 0.2) {
  translate([0, -depth / 2, 0]) {
    baseThickness = wall_thickness + tolerance * 2;
    baseHeight = wall_thickness * 2;
  
    translate([-tolerance, 0, 0]) {
      rotate(-90, [1, 0, 0]) {
        linear_extrude(height=depth) {
            polygon(points=[[0,0],[0, baseHeight],[baseThickness, 0]], paths=[[0,1,2]]);
        }
      }  
    }
  
    translate([tolerance, 0, 0]) {
      cube(size=[wall_thickness, depth, wall_thickness]);
    }
  }
}

wall_thickness = 2;
tolerance = 0.2;
depth = 20;

// !wall_mounted_stopper(depth=depth, wall_thickness=wall_thickness, tolerance=tolerance);