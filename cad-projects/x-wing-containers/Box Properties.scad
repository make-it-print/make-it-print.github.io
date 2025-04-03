WallThickness = 3;
CornerRadius = 4;
Tolerance = 5;
function createBoxProperties(width = 214, depth = 214, height = 60, wall_thickness = 2, radius = 5, tolerance = 0.1) = [width, depth, height, wall_thickness, radius, tolerance];

function getValueOrDefault(value, default) = is_undef(value) ? default : value;
function getRadius(radius, boxProperties) = getValueOrDefault(radius, boxProperties[CornerRadius]);
function getTolerance(tolerance, boxProperties) = getValueOrDefault(tolerance, boxProperties[Tolerance]);
function getWallThickness(wall_thickness, boxProperties) = getValueOrDefault(wall_thickness, boxProperties[WallThickness]);
function getWidth(width, boxProperties) = getValueOrDefault(width, boxProperties.x);
function getDepth(depth, boxProperties) = getValueOrDefault(depth, boxProperties.y);
function getHeight(height, boxProperties) = getValueOrDefault(height, boxProperties.z);

function mutateBoxProperties(boxProperties, width, depth, height, wall_thickness, radius, tolerance) = [
  is_undef(width) ? boxProperties.x : width, 
  is_undef(depth) ? boxProperties.y : depth, 
  is_undef(height) ? boxProperties.z : height, 
  is_undef(wall_thickness) ? boxProperties[WallThickness] : wall_thickness, 
  is_undef(radius) ? boxProperties[CornerRadius] : radius, 
  is_undef(tolerance) ? boxProperties[Tolerance] : tolerance
];