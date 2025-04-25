include <Box Properties.scad>
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

module box_base_shape(boxProperties, top_radius, bottom_radius) {
  $fn = $preview ? 16 : 64;

  top_radius = getRadius(top_radius, boxProperties);
  bottom_radius = getRadius(bottom_radius, boxProperties);

  hull() {
    offset = max(top_radius, bottom_radius);

    for (x=[offset, boxProperties.x - offset]) {
      for (y=[offset, boxProperties.y - offset]) {
        translate([x, y, 0]) {
          cylinder(r1 = bottom_radius, r2 = top_radius, h = boxProperties.z);  
        }
      }
    }
  }
}

function getRadiusOrMinimum(radius, min) = radius < min ? min : radius;

module box_walls(boxProperties, top_radius, bottom_radius) {
  top_radius = getRadius(top_radius, boxProperties);
  bottom_radius = getRadius(bottom_radius, boxProperties);

  difference() {
    box_base_shape(boxProperties, top_radius, bottom_radius);
    translate([0, 0, -boxProperties[WallThickness]]) {
      negative_top_radius = getRadiusOrMinimum(top_radius - boxProperties[WallThickness], 1);
      negative_bottom_radius = getRadiusOrMinimum(bottom_radius - boxProperties[WallThickness], 1);

      translate([boxProperties[WallThickness], boxProperties[WallThickness], 0]) {
        negativeProperties = mutateBoxProperties(
          boxProperties,
          width = boxProperties.x - boxProperties[WallThickness] * 2, 
          depth = boxProperties.y - boxProperties[WallThickness] * 2, 
          height = boxProperties.z + boxProperties[WallThickness] * 2);

        box_base_shape(negativeProperties, negative_top_radius, negative_bottom_radius);
      }
    }
  }
}

module box_base(boxProperties, lid = false) {
  union() {
    // Bottom
    bottomProperties = mutateBoxProperties(boxProperties, height = boxProperties[WallThickness]);
    box_base_shape(bottomProperties);
      
    // Walls
    translate([0, 0, boxProperties[WallThickness]]) {
      if (!lid) {
        box_walls(boxProperties);
      }
    }
  }
}

module wall_reinforcement(boxProperties) {
  reinforcementHeight = 6;
  reinforcementWidth = boxProperties.x + boxProperties[WallThickness] * 2;
  reinforcementDepth = boxProperties.y + boxProperties[WallThickness] * 2;
  reinforcementRadius = boxProperties[CornerRadius] + boxProperties[WallThickness];

  translate([-boxProperties[WallThickness], -boxProperties[WallThickness], -reinforcementHeight]) {
    reinforcementProps = mutateBoxProperties(
      boxProperties, 
      width = reinforcementWidth, 
      depth = reinforcementDepth, 
      height = reinforcementHeight);

    box_walls(reinforcementProps, reinforcementRadius, boxProperties[CornerRadius]);

    translate([0, 0, reinforcementHeight]) {
      difference() {

        reinforcementNegativeProps = mutateBoxProperties(
          reinforcementProps, 
          height = boxProperties[WallThickness] * 2);
        box_walls(reinforcementNegativeProps, top_radius = reinforcementRadius, bottom_radius = reinforcementRadius);

        gapSizeX = boxProperties.x / 2 + boxProperties[WallThickness] * 3;
        gapSizeY = boxProperties.y / 2 + boxProperties[WallThickness] * 3;
        translate([-boxProperties[WallThickness] - 0.01, (reinforcementDepth - gapSizeY) / 2, 0]) {
          cube(size=[reinforcementWidth + boxProperties[WallThickness] * 2, gapSizeY, 10]);
        }

        translate([(reinforcementWidth - gapSizeX) / 2, -boxProperties[WallThickness] - 0.01, 0]) {
          cube(size=[gapSizeX, reinforcementDepth + boxProperties[WallThickness] * 2, 10]);
        }
      }
    }
  }
}

module boxOuterWallClipShape(boxProperties) {
  negativeWallsWidth = boxProperties[WallThickness] * 10;

  translate([-negativeWallsWidth, -negativeWallsWidth, 0]) {
    properties = mutateBoxProperties(boxProperties,
      wall_thickness = negativeWallsWidth,
      width = boxProperties.x + negativeWallsWidth * 2, 
      depth = boxProperties.y + negativeWallsWidth * 2, 
      height = boxProperties.z + boxProperties[WallThickness] * 2,
      radius = boxProperties[CornerRadius] + negativeWallsWidth
    );

    box_walls(properties);
  }
}

function boxInnerWidth(boxProperties) = boxProperties.x - boxProperties[WallThickness] * 2;
function boxInnerDepth(boxProperties) = boxProperties.y - boxProperties[WallThickness] * 2;


module box(boxProperties) {
  box_base(boxProperties, false);
 
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
      wall_reinforcement(boxProperties);
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
      notchProperties = mutateBoxProperties(boxProperties, width = bottomNotchWidth, depth = bottomNotchDepth);
      box_walls(notchProperties);

      translate([-boxProperties[WallThickness], boxProperties[CornerRadius], -boxProperties[WallThickness]]) {
        cube(size=[boxProperties.x + boxProperties[WallThickness] * 2, bottomNotchDepth - boxProperties[CornerRadius] * 2, 10]);
      }

      translate([boxProperties[CornerRadius], -boxProperties[WallThickness], -boxProperties[WallThickness]]) {
        cube(size=[bottomNotchWidth - boxProperties[CornerRadius] * 2, boxProperties.y + boxProperties[WallThickness] * 2, 10]);
      }
    }
  }

  // reinforcement
  reinforcementProperties = mutateBoxProperties(boxProperties, wall_thickness = boxProperties[WallThickness] * 2.1);
  box_walls(reinforcementProperties);

  // top
  translate([0, 0, boxProperties.z]) {
    lidTopProperties = mutateBoxProperties(boxProperties, height = 0);
    box_base(lidTopProperties, true);
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

function boxInsertOffset(boxProperties) = boxProperties[WallThickness] + boxProperties[Tolerance];
function boxInsertWidth(boxProperties) = boxProperties.x - boxInsertOffset(boxProperties) * 2;
function boxInsertDepth(boxProperties) = boxProperties.y - boxInsertOffset(boxProperties) * 2;

module box_insert(boxProperties) {
  offset = boxInsertOffset(boxProperties);
  radius = getRadiusOrMinimum(boxProperties[CornerRadius] - offset, 0.01);

  insertProperties = mutateBoxProperties(
      boxProperties,
      width = boxInsertWidth(boxProperties),
      depth = boxInsertWidth(boxProperties),
      height = 6,
      wall_thickness = 1,
      radius = radius,
      tolerance = boxProperties[Tolerance]);

  translate([offset, offset, 0]) {
    box_walls(insertProperties);    

    if ($children > 0) {
      childrenOffset = insertProperties[WallThickness];
  
      difference() {
        union() {
          translate([childrenOffset, childrenOffset, 0]) {
            for(i=[0:$children-1])
              children(i);  
          }
        }
  
        if (!$preview)
          boxOuterWallClipShape(insertProperties);
      }
    }
  }
}


wall_width = 2;
inner_wall_width = 1.6;
width = 50;
depth = 120;
height = 20;
radius = 5;
tolerance = 0.2;

prod = true;
showBox = true;
showLid = false;
showInsert = true;

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

  if (showInsert) {
    #box_insert(properties);
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
  tongueDepth = 15;
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
