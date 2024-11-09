# Thin Walls
Some walls might be too thin to print. In this case the slicer will generate the paths that overlap resulting in over-extrusion.

Here's an example:

![thin walls](Thin-walls-sliced.png)

And here's how it looks:
![Thin walls print fail side](thin-walls-fail-side.png)
![Thin walls print fail top](thin-walls-fail-top.png)

# Experimenting
I cut out the problematic part of the model and made an experimental plate with three different settings:

1. Original settings
![Original settings](test-original-settings.png)
2. Tweaked X-Y Hole Compensation & X-Y Contour Compensation. Hole compensation helped close invisible gaps and reduced the amount of outer walls generated. Contour compensation increased the size of perimeters so print lines stopped intersecting.
![X-Y Compensation](test-x-y-compensation.png)
3. Enabled thin walls detection. Now the slicer started producing single lines, but the end result has some ugly artifacts.
![Detect thin walls](test-detect-thin-walls.png)

Here are the print results:
![Test results top](test-results-top.png)
1. ![Original](test-result-1.png)
2. ![Thicker walls](test-result-2.png)
3. ![Thin walls detection](test-result-3.png)