use <../x-wing-containers/Primitives.scad>

module pin_with_ring_hole_cut(width, depth, height) {
  translate([-width, -depth/2, -1]) {
    cube(size=[width, depth, height + 2]);
  }
}

module pin_with_ring() {
  length = 210;
  radius = 6;
  holeRadius = 6 / 2;
  thickness = 4;
  stemWidth = 10;
  pointLength = 20;

  difference() {
    union() {
      difference() {
        cylinder(r=radius, h=thickness);
    
        translate([0, 0, -1]) {
          cylinder(r=holeRadius, h=thickness + 2);
        }
      }
      
      stemLength = length - radius - holeRadius - pointLength;
    
      translate([holeRadius, -stemWidth/2, 0]) {
        cube(size=[stemLength, 10, thickness]);
      }
      
      translate([holeRadius + stemLength, stemWidth/2, 0]) {
        rotate(90, [1, 0, 0]) {
          triangular_profile(20, stemWidth, thickness, points=[
            [0, 1],[1, 0.5], [0, 0]
          ]);
        }
      }
    }

    

    rotate(10, [0, 0, 1]) {
      pin_with_ring_hole_cut(radius + 1, holeRadius, thickness);
    }

    rotate(-10, [0, 0, 1]) {
      pin_with_ring_hole_cut(radius + 1, holeRadius, thickness);
    }

    //rotate(45, [0, 0, 1]) {
    //  translate([0, 0, -1]) {
    //    cube(size=[1, radius * 2, thickness + 2]);
    //  }
    //}
  }
  
}


pin_with_ring();