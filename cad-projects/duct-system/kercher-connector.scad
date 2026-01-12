include <duct-properties.scad>
use <straight-duct.scad>
use <../Math.scad>

module duct_to_pipe_connector(args, pipe_length = 60, pipe_diameter = 56) {
  pipeOuterDiameter = pipe_diameter + args[Thickness] * 2;
  
  difference() {
    union() {
      translate([0, 0, -pipe_length]) {
        cylinder(d=pipeOuterDiameter, h=args.y + pipe_length);
      }

      translate([-args.x /2, 0, 0]) {
        rotate(90, [1, 0, 0]) {
          translate([0, -pipe_length, -pipeOuterDiameter / 2]) {
            #cube([args[Width], args[Height] + pipe_length, pipeOuterDiameter / 2]);  
          }
          
          duct_straight(args);

          translate([args[Thickness], args[Thickness], 0]) {
            duct_connector(mutateDuctProperties(args, connectorLength = args[Length] + args[ConnectorLength]));
          }
        }  
      }
    }

    translate([0, 0, -pipe_length - args[Thickness] - 1]) {
      cylinder(d= pipe_diameter, h=args.y + pipe_length - args[Tolerance]);
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
args = createDuctProperties(40, 100, 40, 2, connectorLength = 50);


duct_to_pipe_connector(args);

