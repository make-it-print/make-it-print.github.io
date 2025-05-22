use <Primitives.scad>

DividerHoleHeight = 3;
DividerHoleDepth = 4;
DividerDistance = 5;
WallThickness = 6;
Tolerance = 7;
function createCompartmentWithDividersProperties(width, depth, height, divider_hole_height, divider_hole_depth, divider_distance, wall_thickness = 1, tolerance = 0.1) = [width, depth, height, divider_hole_height, divider_hole_depth, divider_distance, wall_thickness, tolerance];
function compartmentWithDividersWallThickness(properties) = (properties[WallThickness] + properties[DividerHoleDepth] + properties[Tolerance]);
function compartmentWithDividersDividerWidth(properties) = properties.x + properties[DividerHoleDepth] * 2;
function compartmentWithDividersNegativeWidth(properties) = compartmentWithDividersDividerWidth(properties) + properties[Tolerance] * 2;
function compartmentWithDividersWidth(properties) = properties.x + compartmentWithDividersWallThickness(properties) * 2;

module compartment_with_dividers_wall(properties) {
  cube(size=[properties[WallThickness], properties.y, properties.z]);
  translate([properties[WallThickness], 0, 0]) {
    holeWidth = properties[DividerHoleDepth] + properties[Tolerance];
    cube(size=[holeWidth, properties.y, properties[DividerHoleHeight]]);
    translate([0, 0, properties[DividerHoleHeight]]) {
      triangular_profile(holeWidth, holeWidth, properties.y, points=[[0, 0],[0, 1], [1, 0]]);
    }

    translate([0, 0, properties.z - properties[DividerHoleHeight]]) {
      cube(size=[holeWidth, properties.y, properties[DividerHoleHeight]]);

      translate([0, 0, -holeWidth]) {
        triangular_profile(holeWidth, holeWidth, properties.y, points=[[0, 0],[0, 1], [1, 1]]);
      }
    }
  }
}


module compartment_divider(properties) {
  cube(size=[compartmentWithDividersDividerWidth(properties), properties[WallThickness], properties.z]);
}

module compartment_end(properties) {
  cube(size=[compartmentWithDividersWidth(properties), properties[WallThickness], properties.z]);
}

module compartment_with_dividers(properties) {
  compartment_end(properties);

  difference() {
    compartmentWallThickness = compartmentWithDividersWallThickness(properties);
    
    union() {
      translate([0, properties[WallThickness], 0]) {
        compartment_with_dividers_wall(properties);
    
        translate([compartmentWallThickness + properties.x, 0, properties.z]) {
          translate([compartmentWithDividersWallThickness(properties), 0, 0]) {
            rotate(180, [0, 1, 0]) {
              compartment_with_dividers_wall(properties);
            }
          }
        }
      
        translate([0, properties.y, 0]) {
          compartment_end(properties);
        }
      }
    }

    negativeProperties = createCompartmentWithDividersProperties(
      width = properties.x + properties[Tolerance] * 2,
      depth = properties.y + properties[Tolerance] * 2,
      height = properties.z + properties[Tolerance] * 2,
      divider_hole_height = properties[DividerHoleHeight],
      divider_hole_depth = properties[DividerHoleDepth],
      divider_distance = properties[DividerDistance],
      wall_thickness = properties[WallThickness],
      tolerance = properties[Tolerance]
    );
  
    translate([0, properties[WallThickness], 0]) {
      divider_count = floor(properties.y / (properties[DividerDistance] + properties[WallThickness]));
    
      translate([properties[WallThickness], properties[DividerDistance], -properties[Tolerance]]) {
        for(y=[0:1:divider_count-1]) {
          translate([0, (properties[DividerDistance] + properties[WallThickness]) * y, 0]) {
            compartment_divider(negativeProperties);
          }
        }
      }
    }  
  }
}

properties = createCompartmentWithDividersProperties(
  width = 40,
  depth = 100,
  height = 40,
  divider_hole_height = 5,
  divider_hole_depth = 1,
  divider_distance = 15,
  wall_thickness = 1.2,
  tolerance = 0.1
);

renderCompartment = true;
renderDivider = false;

if (renderCompartment) {
  compartment_with_dividers(properties);
}

if (renderDivider) {
  translate([properties[WallThickness] + properties[Tolerance], properties[DividerDistance], properties.z]) {
    compartment_divider(properties);
  }
}


