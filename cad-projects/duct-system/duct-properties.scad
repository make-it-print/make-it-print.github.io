Width = 0;
Height = 1;
Length = 2;
Thickness = 3;
Tolerance = 4;
ConnectorLength = 5;

function createDuctProperties(width = 214, height = 214, length = 60, thickness = 2, tolerance = 0.1, connectorLength = 30) = [width, height, length, thickness, tolerance, connectorLength];

function mutateDuctProperties(ductProperties, width, height, length, thickness, tolerance, connectorLength) = [
  is_undef(width) ? ductProperties[Width] : width,
  is_undef(height) ? ductProperties[Height] : height,
  is_undef(length) ? ductProperties[Length] : length,
  is_undef(thickness) ? ductProperties[Thickness] : thickness,
  is_undef(tolerance) ? ductProperties[Tolerance] : tolerance,
  is_undef(connectorLength) ? ductProperties[ConnectorLength] : connectorLength
];