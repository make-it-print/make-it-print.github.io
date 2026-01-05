include <duct-properties.scad>
use <straight-duct.scad>
use <../Math.scad>

module duct_to_pipe_connector(args, pipe_length = 40, pipe_diameter = 56) {
  difference() {
    union() {
      translate([0, 0, -pipe_length]) {
        cylinder(r=pipe_diameter / 2, h=args.y + pipe_length);
      }

      translate([-args.x /2, 0, 0]) {
        rotate(90, [1, 0, 0]) {
          translate([0, -pipe_length, -pipe_diameter / 2]) {
            cube([args[Width], args[Height] + pipe_length, pipe_diameter / 2]);  
          }
          
          duct_straight(args);

          translate([args[Thickness], args[Thickness], 0]) {
            duct_connector(mutateDuctProperties(args, connectorLength = args[Length] + args[ConnectorLength]));
          }
        }  
      }
    }

    translate([0, 0, -pipe_length - args[Thickness]]) {
      cylinder(r=pipe_diameter / 2- args[Thickness], h=args.y + pipe_length);
    }

    translate([-args.x /2 + args[Thickness], 0, args[Thickness]]) {
      rotate(90, [1, 0, 0]) {
        negativeProperties = mutateDuctProperties(
          createDuctConnectorProperties(args), 
          length = args[Length] + args[ConnectorLength]);

        duct_straight_negative(negativeProperties);
      }  
    }
  }
  
  
  
}

//args = createDuctProperties(40, 100, 40, 2, connectorLength = 40);
args = createDuctProperties(40, 40, 30, 2, connectorLength = 10);


duct_to_pipe_connector(args);

