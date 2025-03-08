module mirror(offsetX, offsetY, offsetZ) {
  translate([offsetX, offsetY, offsetZ]) {
    children(0);
  }

  translate([-offsetX, -offsetY, -offsetZ]) {
    children(0);
  }
}


module center(width, depth, height) {
  translate([-width / 2, -depth / 2, -height / 2]) {
    children();
  }
}