use <Primitives.scad>

DividerHoleHeight = 3;
DividerHoleDepth = 4;
DividerHeight = 5;
DividerDistance = 6;
WallThickness = 7;
Tolerance = 8;
function createCompartmentWithDividersProperties(width, depth, height, divider_hole_height, divider_hole_depth, divider_height, divider_distance, wall_thickness = 1, tolerance = 0.1) = [width, depth, height, divider_hole_height, divider_hole_depth, divider_height, divider_distance, wall_thickness, tolerance];
function compartmentWithDividersOuterWidth(properties) = properties.x + compartmentWithDividersHoleWidth(properties) * 2;
function compartmentWithDividersHoleWidth(properties) = properties[WallThickness];

module compartment_with_dividers_wall(properties) {
  cube(size=[properties[WallThickness], properties.y, properties.z]);
}


module compartment_divider(properties) {
  rotate(-15, [1, 0, 0]) {
    union() {
      translate([compartmentWithDividersHoleWidth(properties), 0, properties[WallThickness] / 2]) {
        cube(size=[properties.x, properties[WallThickness], properties.z]);  
      }
    
      translate([0, 0, properties.z]) {
        cube(size=[compartmentWithDividersOuterWidth(properties), properties[WallThickness], properties[DividerHeight] - properties.z]);
      }
    }
  }

  translate([compartmentWithDividersHoleWidth(properties), 0, 0]) {
    translate([0, properties[WallThickness] / 2, 0]) {
      cube(size=[properties.x, 10, properties[WallThickness]]);
    }

    translate([0, properties[WallThickness] / 2, properties[WallThickness] / 2]) {
      rotate(90, [0, 1, 0]) {
        cylinder(r= properties[WallThickness]/2, h=properties.x,$fn=16);
      }
    }
  }

  
}


module compartment_end(properties) {
  cube(size=[compartmentWithDividersOuterWidth(properties), properties[WallThickness], properties.z]);
}

module compartment_with_dividers(properties) {
  
  union() {
    compartment_end(properties);

    translate([0, properties[WallThickness], 0]) {
      compartment_with_dividers_wall(properties);
  
      compartmentWallThickness = properties[WallThickness];
      translate([compartmentWithDividersOuterWidth(properties) - compartmentWallThickness, 0, 0]) {
          compartment_with_dividers_wall(properties);
      }
    
      translate([0, properties.y, 0]) {
        compartment_end(properties);
      }
    }
  }
}

properties = createCompartmentWithDividersProperties(
  width = 35,
  depth = 100,
  height = 20,
  divider_hole_height = 10,
  divider_hole_depth = 3,
  divider_height = 30,
  divider_distance = 10,
  wall_thickness = 1.2,
  tolerance = 0.2
);

renderCompartment = true;
renderDivider = false;

if (renderCompartment) {
  compartment_with_dividers(properties);

  translate([compartmentWithDividersOuterWidth(properties) - properties[WallThickness], 0, 0]) {
    compartment_with_dividers(properties);
  }
}

if (renderDivider) {
  translate([
    0, 
    properties[DividerDistance] + properties[WallThickness], 0]) {
    compartment_divider(properties);
  }
}


