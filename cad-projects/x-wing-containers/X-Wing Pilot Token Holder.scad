use <Primitives.scad>

DividerHoleHeight = 3;
DividerHoleDepth = 4;
DividerDistance = 5;
WallThickness = 6;
Tolerance = 7;
function createCompartmentWithDividersProperties(width, depth, height, divider_hole_height, divider_hole_depth, divider_distance, wall_thickness = 1, tolerance = 0.1) = [width, depth, height, divider_hole_height, divider_hole_depth, divider_distance, wall_thickness, tolerance];
function compartmentWithDividersWallThickness(properties) = (properties[WallThickness] + compartmentWithDividersHoleWidth(properties));
function compartmentWithDividersDividerWidth(properties) = properties.x + properties[DividerHoleDepth] * 2;
function compartmentWithDividersWidth(properties) = properties.x + compartmentWithDividersWallThickness(properties) * 2;
function compartmentWithDividersHoleWidth(properties) = properties[DividerHoleDepth] + properties[Tolerance];
function compartmentWithDividersHoleDepth(properties) = properties[WallThickness] * 3 + properties[Tolerance]  * 2;

module compartment_with_dividers_wall(properties) {
  translate([compartmentWithDividersHoleWidth(properties), 0, 0]) {
    cube(size=[properties[WallThickness], properties.y, properties.z]);
  }
}


module compartment_divider_hole(properties) {
  cube(size=[
    compartmentWithDividersHoleWidth(properties), 
    compartmentWithDividersHoleDepth(properties), 
    properties.z]);
}


module compartment_divider(properties) {
  cube(size=[compartmentWithDividersDividerWidth(properties), properties[WallThickness], properties.z]);
}

module compartment_end(properties) {
  translate([compartmentWithDividersHoleWidth(properties), 0, 0]) {
    cube(size=[compartmentWithDividersWidth(properties) - (compartmentWithDividersHoleWidth(properties)) * 2, properties[WallThickness], properties.z]);
  }
}

module compartment_with_dividers(properties) {
  divider_count = floor(properties.y / (properties[DividerDistance] + properties[WallThickness]));
  
  compartment_end(properties);

  difference() {
    compartmentWallThickness = compartmentWithDividersWallThickness(properties);
    
    union() {
      translate([0, properties[WallThickness], 0]) {
        compartment_with_dividers_wall(properties);

        {
          holeOffset = (compartmentWithDividersHoleDepth(properties) - properties[WallThickness]) / 2;
          translate([0, properties[DividerDistance], 0]) {
            for(y=[0:1:divider_count-1]) {
              translate([0, (properties[DividerDistance] + properties[WallThickness]) * y - holeOffset, 0]) {
                compartment_divider_hole(properties);

                translate([properties.x + compartmentWithDividersWallThickness(properties) + properties[WallThickness], 0, 0]) {
                  compartment_divider_hole(properties);
                }
              }
            }
          }
        }
    
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
      wall_thickness = properties[WallThickness] + properties[Tolerance] * 2,
      tolerance = properties[Tolerance]
    );
  
    translate([0, properties[WallThickness], 0]) {
      translate([properties[WallThickness], properties[DividerDistance], -properties[Tolerance]]) {
        for(y=[0:1:divider_count-1]) {
          translate([0, (properties[DividerDistance] + properties[WallThickness]) * y - properties[Tolerance], 0]) {
            compartment_divider(negativeProperties);
          }
        }
      }
    }  
  }
}

properties = createCompartmentWithDividersProperties(
  width = 35,
  depth = 100,
  height = 20,
  divider_hole_height = 5,
  divider_hole_depth = 1,
  divider_distance = 10,
  wall_thickness = 1.2,
  tolerance = 0.2
);

renderCompartment = true;
renderDivider = true;

if (renderCompartment) {
  compartment_with_dividers(properties);
}

if (renderDivider) {
  translate([
    properties[WallThickness] + properties[Tolerance], 
    properties[DividerDistance] + properties[WallThickness], properties.z]) {
    compartment_divider(properties);
  }
}


