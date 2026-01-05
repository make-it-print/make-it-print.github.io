standThickness = 5;
standDiameter = 120;
standHeight = 30;
rodDiameter = 6;
tolerance = 0.5;
rodHolderOuterDiameter = 20;
rodHolderInnerDiameter = 10;

$fn = $preview ? 16 : 128;

module lamp_stand(args) {
  
  
  cylinder(r=standDiameter/2, h=standThickness, center=false);
  difference() {
    cylinder(d1=rodHolderOuterDiameter, d2=rodHolderInnerDiameter, h=standHeight, center=false);
  
    translate([0, 0, 5]) {
      cylinder(d=rodDiameter + tolerance, h=standHeight + 2, center=false);
    }
  }
}


module lamp_holder(args) {
  holderWidth = 36;
  lampDiameter = 27 + tolerance;
  lampHeight = 46;
  lampCordSpaceHeight = 15;
  thickness = 4;
  
  difference() {
    union() {
      cylinder(d=lampDiameter + thickness, h=lampHeight + lampCordSpaceHeight, center=false);
      translate([0, 0, lampHeight + lampCordSpaceHeight]) {
        sphere(d=lampDiameter + thickness);
      }
    }

    union() {
      translate([0, 0, -1]) {
        cylinder(d=lampDiameter, h=lampHeight + 1, center=false);
      }
  
      translate([0, 0, lampHeight]) {
        cylinder(d1=lampDiameter, d2=rodHolderInnerDiameter, h=lampCordSpaceHeight, center=false);
      }

      translate([-7/2, 0, -1]) {
        cube(size=[7, lampDiameter, lampHeight + lampCordSpaceHeight + 1], center=false);
      }

      translate([0, 0, lampHeight + lampCordSpaceHeight + 2]) {
        cylinder(d=rodDiameter + tolerance, h=100, center=false);
      }
    }
  }
}

module lamp_ring(args) {
  lampDiameter = 150;
  lampHeight = 7;
  ringThickness = 3;
  thickness = 1;
  
  difference() {
    union() {
      cylinder(d=lampDiameter, h=lampHeight, center=false);
      translate([lampDiameter / 2, 0, lampHeight / 2]) {
        cube(size=[60, 27, lampHeight], center=true);
      }
    }

    union() {
      translate([0, 0, -1]) {
        cylinder(d=lampDiameter - ringThickness, h=lampHeight + 2, center=false);

        translate([lampDiameter / 2 - 1, 0, lampHeight / 2 + 1]) {
          cube(size=[60 + 3, 27 - thickness * 2, lampHeight + 2], center=true);
        }
      }
  
      
    }
  }
}

//lamp_holder();
//lamp_stand();
lamp_ring();