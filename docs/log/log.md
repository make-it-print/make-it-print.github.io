# Observations log
This is my printing diary where I'm going to record all interesting observations, problems, workarounds and etc.

## 2025-01-09 0.8 nozzle setup

### Printer setup
Setup the nozzle in my printer. 

Copy pasted main settings from Creality Print to Orca and noticed that:
1. 0.8 nozzle is set up to print much slower, i.e. around 100 mm/s, but with higher accel_to_decel
1. Filament profiles are also a bit differently configured. Flow rate is a bit higher that at the same filament but smaller nozzle.

This is due to the max volumetric flow limitation on the filament. **TODO**: and see if I can go faster!

### Z-Offset
Calibrated first layer squish. Not happy with the results. Landed on 0.03 z-offset. Got an almost ridge-free first layer, but with some pin holes and gaps on the other side. But going lower produces too much ridges! So stopped on a compromise for now.

### PA
Did a draft PA test. A value around 0.005 looks good.

### Z-Offset Issue
Now this is ridiculous! Tried to print a test cube to do a quick check on all the line types and see if the flow value I copied from Creality is OK. Had to stop it on the first layer because it was obvious that there is not enough squish!!! Reset z-offset back to zero.

### Test Cube
Test cube turned out OK:
1. First layer: needs more squish. **TODO**: Increase first layer line width and improve first layer
1. Walls: Visible gaps in the corners. Especially in one of them. Probably due to too large seam gap. **TODO**: increase inner line width, also infill width. And try decreasing seam gap.
1. Infill: No issues at all
1. Internal bridge: Looks solid
1. Top layer: a bit of ridges closer to walls. Maybe less flow? **TODO**: calibrate flow

### Z-Offset Issue
Now I know what happened with z-offset. Some **filament got stuck** to the nozzle and **messed up z-offset** during the cleaning sequence before print.  I saw it when after nozzle cleaning the printer **didn't touch the bed**! Super strange, but now I'll keep an eye on that.

### Z-Offset
Set z-offset to -0.03 now. Still see gaps on the other side

### Line Widths???
Not sure when exactly did I do this, but i increase line widths a bit: set 120% line width on: sparse infill, first layer and inner wall. :(

### Seam
Reduced seam gap from 10% to 5%. Better, but not enough. Adjusted z-offset to -0.04.

Reduced seam gap to 3% and enabled wipe on loops and wipe before external loop. Printed test cube. Seam settings seemed to help. 

### Max Flow
Did max flow test. The test suggested that the maximum flow could be up to 41. Set it up and did a test print. It looks like it is way too high! Infill lines do not stick to the walls at all.

Tried different options:
1. Reduced accel_to_decel from 80 to 25.
1. Increased temp from 220 to 240.
1. Increased infill overlap %
1. Noticed that i had default PA (0.04) which is too big all this time and set it to 0.005.
Nothing helped. Reverted all the settings.

Reduced max flow to 30. Same. So changed it back to: 23 (default).

### Z-Offset Issue
Looks like dirty nozzle and z-offset issue was a bug. Forgot to clean the nozzle and it worked just fine without nozzle stopping in the air.

### Seam
After a couple of more test prints. I Increase the seam gap back to 10% and disabled seam wipes. They helped only because of too high default PA. With good PA they make the seam look over extruded.

### Flow Rate
Reduced flow rate from 0.98 to 0.95. As it seems like it's a bit high on the latest prints. Gaps on the first layer appeared and no improvements anywhere else.

Changed z-offset to -0.03. Too many ridges on all prints. A bit better.

### PA Smooth Time
According to [this](https://klipper.discourse.group/t/pressure-advance-smooth-time-on-direct-extruders-with-short-filament-path/1971) reducing PA Smooth Time might help with larger nozzles. Put ```SET_PRESSURE_ADVANCE SMOOTH_TIME=0.01``` into printer's profile start G-Code.

I'll have to increase the PA after that as well.

Test print showed no noticeable difference. Will try calibrating PA and give it another shot.

Did another PA test with decreased smooth value. New PA has indeed increase from 0.005 to 0.009. This is due to shorter segment where PA kicks in!

Printed test cube. Looks good!

### Deretraction
While doing last PA test, noticed that the nozzle squeezes out way too much plastic when landing! Need to investigate.

Created a test that print a long 2 layer patch and a bunch of short separated lines (enable detect thin lines to make them work). The issue i noticed during PA test was due to much wider first layer lines set by the test. What I saw when printing with my current settings is that there's a slight under extrusion after deretraction, so it needs to be faster. I'd increase retraction speed as well.

Increased retract speed from 40 to 50 and deretract speed from 40 to 60. Also increased travel distance threshold from 1mm (Creality default) to 2mm.

No effect. Reverted retraction settings back, but left the travel distance threshold in place.

### Seam
Decided to give another shot at seam gap.

Enabled staggered inner seams and wipe on loops. Left wipe before external loop disabled, because I do not have the problem with over extrusion at the start of the line. It's quite the opposite.

Worked well. The seam became less bulged!

### Print speed
Decided to try to find a combination of parameters to make it print faster. The last time i didn't play with acceleration. Let's try to reduce the acceleration and increase the flow!

Still no. Small accelerations helped a bit, but not enough.

### Bridges and overhangs

Disabled slow down for curled perimeters and thick internal bridges and got a pretty good result.



