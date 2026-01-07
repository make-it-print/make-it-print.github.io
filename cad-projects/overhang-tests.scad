function calc_d2(h, d1, angle) = d1 - 2 * h * tan(angle);
//$fn = $preview ? 16 : 128;

height = 5;
base_diameter = 25;

$fn = 4;

module overhang(sides, angle, base_size, height) {
  rotate(180, [1, 0, 0]) {
    $fn = sides;
    cylinder(d1=base_size, d2=calc_d2(height, base_size, angle), h=height, center=true);
  }
}

// rect 45
//overhang(4, 45, base_diameter, height);

// rect 30
//overhang(4, 30, base_diameter, height);

// cyl 45
//overhang($preview ? 16 : 128, 45, base_diameter, height);

// cyl 30
overhang($preview ? 16 : 128, 30, base_diameter, height);


