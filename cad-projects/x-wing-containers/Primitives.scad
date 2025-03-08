module triangular_profile(width, height, depth, points=[[0.5, 0.5],[1, 0], [0, 0]]){
  translate([0, depth, 0]) {
    rotate(90, [1, 0, 0]) {
      linear_extrude(height=depth) {
        polygon(
          points=[
            [width * points[0][0], height * points[0][1]], // top
            [width * points[1][0], height * points[1][1]], // right
            [width * points[2][0], height * points[2][1]] // left
          ], 
          paths=[[0,1,2]]
        );
      }
    }
  }
}