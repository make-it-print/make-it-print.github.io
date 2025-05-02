WallThickness = 3;
CornerRadius = 4;
Tolerance = 5;
InnerWallThickness = 6;
function createBoxProperties(width = 214, depth = 214, height = 60, wall_thickness = 2, radius = 5, tolerance = 0.1, inner_wall_thickness = 1.6) = [width, depth, height, wall_thickness, radius, tolerance, inner_wall_thickness];

function getValueOrDefault(value, default) = is_undef(value) ? default : value;
function getRadius(radius, boxProperties) = getValueOrDefault(radius, boxProperties[CornerRadius]);
function getTolerance(tolerance, boxProperties) = getValueOrDefault(tolerance, boxProperties[Tolerance]);
function getWallThickness(wall_thickness, boxProperties) = getValueOrDefault(wall_thickness, boxProperties[WallThickness]);
function getInnerWallThickness(inner_wall_thickness, boxProperties) = getValueOrDefault(inner_wall_thickness, boxProperties[InnerWallThickness]);
function getWidth(width, boxProperties) = getValueOrDefault(width, boxProperties.x);
function getDepth(depth, boxProperties) = getValueOrDefault(depth, boxProperties.y);
function getHeight(height, boxProperties) = getValueOrDefault(height, boxProperties.z);

function mutateBoxProperties(boxProperties, width, depth, height, wall_thickness, radius, tolerance, inner_wall_thickness) = [
  is_undef(width) ? boxProperties.x : width, 
  is_undef(depth) ? boxProperties.y : depth, 
  is_undef(height) ? boxProperties.z : height, 
  is_undef(wall_thickness) ? boxProperties[WallThickness] : wall_thickness, 
  is_undef(radius) ? boxProperties[CornerRadius] : radius, 
  is_undef(tolerance) ? boxProperties[Tolerance] : tolerance,
  is_undef(inner_wall_thickness) ? boxProperties[InnerWallThickness] : inner_wall_thickness
];