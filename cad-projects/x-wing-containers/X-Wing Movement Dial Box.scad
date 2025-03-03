use <X-Wing Movement Dial Surface.scad>
use <X-Wing Box.scad>

wall_width = 2;
inner_wall_width = 1.6;
width = 220 - 6;
depth = 220 - 6;
height = 50;
radius = 5;

box(wall_width, width, depth, height, radius);
// TODO: increase the holder height
movement_dial_holder_surface(inner_wall_width, width, depth);

translate([0, depth + 10, 0]) {
 lid(wall_width, width, depth, radius);  
}
