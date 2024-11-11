# Printer Calibration

## Prerequisites
Make sure your printer is pre-calibrated on normal settings. 
If you haven't yet calibrated extruder, flow, PA, bed leveling or your first layer go through the materials on [Ellis' Print Tuning Guide](https://ellis3dp.com/Print-Tuning-Guide/articles/index_tuning.html) first.

## Why calibrating again?
Here's a quote from [Creality's documentation](https://wiki.creality.com/en/software/creality-print/parameter-quality#h-11-layer-height-vs-configuration-file):

> 1.1 Layer height vs. configuration file
>
>  Many settings depend on **layer height**. Because layer height significantly **affects the flow rate** of material through the nozzle, many parameters of the printing process will change. This has a certain level of complexity. For example, when increasing layer height, you may need to increase the print temperature slightly to offset the additional heat loss.
>
>  Temperature affects the fluidity of the material, thereby affecting Corner sharpness and required coolingetc. Therefore, it's best to start with a preset quality profile provided by your printer that has a layer height close to your desired layer height.

So, knowing that we'll have to do an almost full recalibration using the selected filament and our target layer height:
1. Flow
2. Pressure Advance
3. PID and maybe filament temperature
4. Shapers
5. Retraction

