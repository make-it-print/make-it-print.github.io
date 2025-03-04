use <X-Wing Movement Dial.scad>
use <X-Wing Box.scad>
use <Box.scad>

wall_width = 2;
inner_wall_width = 1.6;
width = 214;
depth = 214;
height = 50;
radius = 5;

box(wall_width, width, depth, height, radius);
// TODO: increase the holder height
movement_dial_holder_surface(inner_wall_width, width, depth);

translate([0, depth + 10, 0]) {
 lid(wall_width, width, depth, radius);  
}
