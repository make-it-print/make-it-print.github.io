
tolerance = 0.2;
radius = 50.2 / 2;
cutOutWidth = 6.2;
holeRadius = 8 / 2 + tolerance;
thickness = 2;
cutOutAngle = 104;

difference() {
  cylinder(r=radius, h=thickness, center=true);

  difference() {
    cylinder(r=radius + 0.1, h=thickness * 2, center=true);
  
    translate([0, 0, -thickness * 2]) {
      translate([-cutOutWidth, -radius * 2, 0]) {
        cube(size=[radius * 4, radius * 4, thickness * 4]);
      }
      
      rotate(180-cutOutAngle, [0, 0, 1]) {
        translate([-cutOutWidth, -radius * 2, 0]) {
          cube(size=[radius * 4, radius * 4, thickness * 4]);
        }
      }
    }
    
    cylinder(r=radius-cutOutWidth, h=thickness * 3, center=true);  
  }
  
  cylinder(r=holeRadius, h=thickness * 2, center=true);
}
