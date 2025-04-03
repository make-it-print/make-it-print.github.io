WallThickness = 3;
CornerRadius = 4;
Tolerance = 5;
function createBoxProperties(width = 214, depth = 214, height = 60, wall_thickness = 2, radius = 5, tolerance = 0.1) = [width, depth, height, wall_thickness, radius, tolerance];

function mutateBoxProperties(boxProperties, width, depth, height, wall_thickness, radius, tolerance) = [
  is_undef(width) ? boxProperties.x : width, 
  is_undef(depth) ? boxProperties.y : depth, 
  is_undef(height) ? boxProperties.z : height, 
  is_undef(wall_thickness) ? boxProperties[WallThickness] : wall_thickness, 
  is_undef(radius) ? boxProperties[CornerRadius] : radius, 
  is_undef(tolerance) ? boxProperties[Tolerance] : tolerance
];