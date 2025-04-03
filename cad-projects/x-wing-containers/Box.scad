use <X-Wing Box Slide Clamp.scad>
use <X-Wing Box Wall Mounts.scad>

module place_wall_mounts_x(boxProperties)
{
  translate([0, boxProperties.y / 2, 0]) {
    rotate(180, [0, 0, 1]) {
      children(0);
    }

    translate([boxProperties.x, 0, 0]) {
        children(1);
    }
  }
}

module place_wall_mounts_y(boxProperties)
{
  translate([boxProperties.x / 2, 0, 0]) {
    rotate(-90, [0, 0, 1]) {
      children(0);
    }

    translate([0, boxProperties.y, 0]) {
      rotate(90, [0, 0, 1]) {
          children(1);
      }
    }
  }
}

function max(a, b) = a > b ? a : b;
function min(a, b) = a < b ? a : b;

module box_base_shape(width, depth, height, top_radius, bottom_radius) {
  $fn = $preview ? 16 : 64;

  hull() {
    offset = max(top_radius, bottom_radius);

    for (x=[offset, width - offset]) {
      for (y=[offset, depth - offset]) {
        translate([x, y, 0]) {
          cylinder(r1 = bottom_radius, r2 = top_radius, h = height);  
        }
      }
    }
  }
}

function getRadiusOrMinimum(radius, min) = radius < min ? min : radius;

module box_walls(wall_width = 2, width = 220, depth = 220, height=50, top_radius=10, bottom_radius=10) {
  difference() {
    box_base_shape(width, depth, height, top_radius, bottom_radius);
    translate([0, 0, -wall_width]) {
      negative_top_radius = getRadiusOrMinimum(top_radius - wall_width, 1);
      negative_bottom_radius = getRadiusOrMinimum(bottom_radius - wall_width, 1);

      translate([wall_width, wall_width, 0]) {
        box_base_shape(
          width - wall_width * 2, 
          depth - wall_width * 2, 
          height + wall_width * 2, 
          negative_top_radius, 
          negative_bottom_radius);
      }
    }
  }
}

module box_base(wall_width = 2, width = 220, depth = 220, height=50, radius=10, lid = false) {
  union() {
    // Bottom
    box_base_shape(width, depth, wall_width, radius, radius);
      
    // Walls
    translate([0, 0, wall_width]) {
      if (!lid) {
        box_walls(wall_width, width, depth, height, radius, radius);
      }
    }
  }
}

module wall_reinforcement(wall_width = 2, width = 220, depth = 220, height=45, radius=10) {
  reinforcementHeight = 6;
  reinforcementWidth = width + wall_width * 2;
  reinforcementDepth = depth + wall_width * 2;
  reinforcementRadius = radius + wall_width;

  translate([-wall_width, -wall_width, -reinforcementHeight]) {
    box_walls(wall_width, reinforcementWidth, reinforcementDepth, reinforcementHeight, reinforcementRadius, radius);
    translate([0, 0, reinforcementHeight]) {
      difference() {
        box_walls(
          wall_width = wall_width, 
          width = reinforcementWidth, 
          depth = reinforcementDepth, 
          height = wall_width * 2, 
          top_radius = reinforcementRadius, 
          bottom_radius = reinforcementRadius);

        gapSizeX = width / 2;
        gapSizeY = depth / 2;
        translate([-wall_width - 0.01, (reinforcementDepth - gapSizeY) / 2, 0]) {
          cube(size=[reinforcementWidth + wall_width * 2, gapSizeY, 10]);
        }

        translate([(reinforcementWidth - gapSizeX) / 2, -wall_width - 0.01, 0]) {
          cube(size=[gapSizeX, reinforcementDepth + wall_width * 2, 10]);
        }
      }
    }
  }
}

module boxOuterWallClipShape(wall_width = 2, width = 220, depth = 220, height=45, radius=10) {
  negativeWallsWidth = wall_width * 10;
  translate([-negativeWallsWidth, -negativeWallsWidth, 0]) {
    box_walls(
      negativeWallsWidth, 
      width + negativeWallsWidth * 2, 
      depth + negativeWallsWidth * 2, 
      height + wall_width * 2, 
      radius + negativeWallsWidth, 
      radius + negativeWallsWidth);
  }
}

function boxInnerWidth(width, wall_thickness = 2) = width - wall_thickness * 2;
function boxInnerDepth(depth, wall_thickness = 2) = depth - wall_thickness * 2;

// TODO
WallThickness = 3;
CornerRadius = 4;
Tolerance = 5;
function createBoxProperties(width = 214, depth = 214, height = 60, wall_thickness = 2, radius = 10, tolerance = 0.1) = [width, depth, height, wall_thickness, radius, tolerance];

function mutateBoxProperties(boxProperties, width, depth, height, wall_thickness, radius, tolerance) = [
  is_undef(width) ? boxProperties.x : width, 
  is_undef(depth) ? boxProperties.y : depth, 
  is_undef(height) ? boxProperties.z : height, 
  is_undef(wall_thickness) ? boxProperties[WallThickness] : wall_thickness, 
  is_undef(radius) ? boxProperties[CornerRadius] : radius, 
  is_undef(tolerance) ? boxProperties[Tolerance] : tolerance
];


module box(boxProperties) {
  box_base(boxProperties[WallThickness], boxProperties.x, boxProperties.y, boxProperties.z, boxProperties[CornerRadius], false);
 
  if ($children > 0) {
    // base mounts
    place_wall_mounts_x(boxProperties) {
      children(0);
      children(1);
    }

    place_wall_mounts_y(boxProperties) {
      children(2);
      children(3);
    }
    
    translate([0, 0, boxProperties.z + boxProperties[WallThickness]]) {
      wall_reinforcement(boxProperties[WallThickness], boxProperties.x, boxProperties.y, boxProperties.z, boxProperties[CornerRadius]);
      place_wall_mounts_x(boxProperties) {
        children(4);
        children(5);
      }
    }
  
    translate([0, 0, boxProperties.z + boxProperties[WallThickness]]) {
      place_wall_mounts_y(boxProperties) {
        children(6);
        children(7);
      }
    }
  }
}

module lid(boxProperties) {
  boxProperties = mutateBoxProperties(boxProperties, height = boxProperties[WallThickness]);

  // Bottom nothces
  translate([boxProperties[WallThickness] + boxProperties[Tolerance], boxProperties[WallThickness] + boxProperties[Tolerance], -boxProperties.z]) {
    difference() {
      bottomNotchWidth = boxProperties.x - (boxProperties[WallThickness] + boxProperties[Tolerance]) * 2;
      bottomNotchDepth = boxProperties.y - (boxProperties[WallThickness] + boxProperties[Tolerance]) * 2;
      box_walls(boxProperties[WallThickness], bottomNotchWidth, bottomNotchDepth, boxProperties.z, boxProperties[CornerRadius], boxProperties[CornerRadius]);

      translate([-boxProperties[WallThickness], boxProperties[CornerRadius], -boxProperties[WallThickness]]) {
        cube(size=[boxProperties.x + boxProperties[WallThickness] * 2, bottomNotchDepth - boxProperties[CornerRadius] * 2, 10]);
      }

      translate([boxProperties[CornerRadius], -boxProperties[WallThickness], -boxProperties[WallThickness]]) {
        cube(size=[bottomNotchWidth - boxProperties[CornerRadius] * 2, boxProperties.y + boxProperties[WallThickness] * 2, 10]);
      }
    }
  }

  // reinforcement
  box_walls(boxProperties[WallThickness] * 2.1, boxProperties.x, boxProperties.y, boxProperties.z, boxProperties[CornerRadius], boxProperties[CornerRadius]);

  // top
  translate([0, 0, boxProperties.z]) {
    box_base(boxProperties[WallThickness], boxProperties.x, boxProperties.y, 0, boxProperties[CornerRadius], true);
  }

  if ($children > 0) {
    place_wall_mounts_x(boxProperties) {
      children(0);
      if ($children > 1)
        children(1);
    }
  }

  if ($children > 2) {
    place_wall_mounts_y(boxProperties) {
      children(2);
      if ($children > 3)
        children(3);
    }
  }
}


wall_width = 2;
inner_wall_width = 1.6;
width = 30;
depth = 80;
height = 10;
radius = 5;
tolerance = 0.2;

prod = false;
showBox = true;
showLid = true;

if (prod) {
  width = 220 - 6;
  depth = 220 - 6;
  height = 60;

  properties = createBoxProperties(width, depth, height, wall_width, radius, tolerance);

  if (showBox) {
    box(properties) {
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      wall_mounted_click_lock(wall_thickness = wall_width, tolerance = 0);
      wall_mounted_click_lock(wall_thickness = wall_width, tolerance = 0);
      double_wall_mount(width) {
        wall_mounted_stopper(wall_thickness = wall_width, tolerance = 0);
      }
      double_wall_mount(width) {
        wall_mounted_stopper(wall_thickness = wall_width, tolerance = 0);
      }
    }

    //translate([0, 0, wall_width]) {
    //  box_walls(wall_width, width, depth, 10, radius, radius + wall_width);
    //}
  }

  if (showLid)
    translate([0, 0, height + wall_width  + 10]) {
      lid(properties) {
        lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
        lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
        lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
        lid_mounted_click_lock_tongue(wall_thickness = wall_width, tolerance = 0);
      }
    }
} 
else 
{
  tongueDepth = 30;
  fullDepth= 30;
  fingerLipDepth = 10;
  
  properties = createBoxProperties(width, depth, height, wall_width, radius);
  
  if (showBox) {
    box(properties) {
      no_mounts();
      wall_mounted_snap_lock_tongue(tongueDepth=tongueDepth, fingerLipDepth = fingerLipDepth, wall_thickness = wall_width);
      no_mounts();
      no_mounts();
      //wall_mounted_click_lock(fullDepth = fullDepth, tongueDepth=tongueDepth, wall_thickness = wall_width, tolerance = 0);
      no_mounts();
      //wall_mounted_click_lock(fullDepth = fullDepth, tongueDepth=tongueDepth, wall_thickness = wall_width, tolerance = 0);
      wall_mounted_snap_lock(tongueDepth=tongueDepth, wall_thickness = wall_width);
      no_mounts();
      no_mounts();
    }
  }

  if (showLid)
    translate([0, 0, height + wall_width + 10]) {
      lid(properties) {
        //lid_mounted_click_lock_tongue(fullDepth = fullDepth, tongueDepth=tongueDepth, fingerLipDepth = fingerLipDepth, wall_thickness = wall_width, tolerance = 0);
        no_mounts();
        //lid_mounted_click_lock_tongue(fullDepth = fullDepth, tongueDepth=tongueDepth, fingerLipDepth = fingerLipDepth, wall_thickness = wall_width, tolerance = 0);
        wall_mounted_snap_lock_tongue(tongueDepth=tongueDepth, fingerLipDepth = fingerLipDepth, wall_thickness = wall_width);
      }
    }
}
