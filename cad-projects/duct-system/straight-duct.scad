include <duct-properties.scad>
use <../Math.scad>

module duct_straight_negative(args) {
  translate([args[Thickness], args[Thickness], -args[Thickness]])
    cube([args[Width] - 2 * args[Thickness], args[Height] - 2 * args[Thickness], args[Length] + 2 * args[Thickness]]);
}

module duct_straight(args) {
  difference() {
    cube([args[Width], args[Height], args[Length]]);

    duct_straight_negative(args);
  }
}

function createDuctConnectorProperties(args) = mutateDuctProperties(
    args, 
    args[Width] - (args[Thickness] + args[Tolerance]) * 2, 
    args[Height] - (args[Thickness] + args[Tolerance]) * 2, 
    args[ConnectorLength], 
    1);

module duct_connector(args) {
  args = createDuctConnectorProperties(args);
  
  duct_straight(args);
}


module duct_90_turn_smooth(args) {
  difference() {
    a = sqrt(args[Width] * args[Width] / 2);
    connectorLength = args[Width] - a;
    minConnectorLength = args[ConnectorLength] / 2;
    l = a + (connectorLength < minConnectorLength ? minConnectorLength - connectorLength: 0);
    union() {
      cube([args[Width], args[Height], l]);
  
      translate([0, 0, l]) {
        rotate(45, [0, 1, 0]) {
          cube([args[Width], args[Height], hypotenuse(args[Width], args[Width])]);
        }
      }
  
      translate([args[Width], 0, args[Width] + l]) {
        rotate(90, [0, 1, 0]) {
          cube([args[Width], args[Height], l]);
        }
      }
    }

    _duct_90_turn_smooth_negative(args, l);

    hull() {
      difference() {
        _duct_90_turn_smooth_negative(args, l);

        translate([-l + args[Thickness] * 4, 0, 0]) {
          rotate(45, [0, 1, 0]) {
            translate([0, -args[Thickness], 0]) {
              cube(size=[args[Width] * 10, args[Height] * 10, l * 10]);
            }
          }  
        }
      }
    }
  }
}


module _duct_90_turn_smooth_negative(args, l) {
  negativeThickness = 2 * args[Thickness];
    negativeWidth = args[Width] - negativeThickness;
    negativeHeight = args[Height] - negativeThickness;

    
    translate([args[Thickness], args[Thickness], -args[Tolerance]]) {
      cube([negativeWidth, negativeHeight, l - args[Thickness] + args[Tolerance]]);
    }

    translate([0, 0, l]) {
      rotate(45, [0, 1, 0]) {
        translate([args[Thickness], args[Thickness], args[Thickness]]) {
          cube([negativeWidth, negativeHeight, hypotenuse(args[Width], args[Width]) - args[Thickness] * 2]);
        }
      }
    }

    translate([args[Width] + args[Thickness], args[Thickness], args[Width] + l - args[Thickness]]) {
      rotate(90, [0, 1, 0]) {
        cube([negativeWidth, negativeHeight, l + args[Tolerance]]);
      }
    }
}


args = createDuctProperties(40, 100, 30, 2);
//duct_straight(args);
//
//translate([args[Thickness] + args[Tolerance], args[Thickness] + args[Tolerance], args[Length] - 15]) {
//  duct_connector(args);
//}

duct_90_turn_smooth(args);