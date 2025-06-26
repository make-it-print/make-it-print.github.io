import { readFileSync, writeFileSync, mkdir } from "node:fs"

let gcode = `; EXECUTABLE_BLOCK_START
M73 P0 R0
M106 S0
M106 P2 S0
;TYPE:Custom
M140 S0
M104 S0
START_PRINT EXTRUDER_TEMP=210 BED_TEMP=55
SET_PRESSURE_ADVANCE SMOOTH_TIME=0.02
G90
G21
M83 ; use relative distances for extrusion
; Filament gcode
; SET_GCODE_OFFSET Z=xxx
; z_offset xxx ???
SET_PRESSURE_ADVANCE ADVANCE=0.03; Override pressure advance value
`;

const firstLayerPA = false;

const zOffset = 0.01;
let layerHeight = 0.4;
const yStep = 15;
const numLines = 14;
const numLayers = firstLayerPA ? 1 : 12;

const fastPaStartValue = 0.0; // 0.03
const fastPaEndValue = 0.06;
const fastPaStep = (fastPaEndValue - fastPaStartValue) / numLines;

const slowPaStartValue = 0.0; // 0.04
const slowPaEndValue = 0.06;
const slowPaStep = (slowPaEndValue - slowPaStartValue) / numLines;

for (let layerIndex = 1; layerIndex <= numLayers; layerIndex++) {

  const z = (layerHeight * layerIndex + zOffset).toFixed(2);
  const currentLayerHeight = (layerHeight * layerIndex).toFixed(2);
  let accel = 5000;
  let accelToDecel = 4000;
  let slowPA = slowPaStartValue;
  let slowExtrusion = 3.34556;//2.50917;
  let fastPA = fastPaStartValue;
  let fastExtrusion = 9.62867;//7.2215;
  let slowFlow = 3600; // 2100 mm/min
  let fastFlow = 3600;
  
  if (layerIndex === 1) {
    accel = 500;
    accelToDecel = 400;

    if (!firstLayerPA) {
      slowPA = 0.032      ;
      fastPA = 0.032;
    }

    slowFlow = 3600;
    fastFlow = 3600;

    gcode += `M106 S0
M106 P2 S0
;LAYER_CHANGE
;Z:${currentLayerHeight}
;HEIGHT:${layerHeight}
;BEFORE_LAYER_CHANGE
;${currentLayerHeight}
G92 E0

;_SET_FAN_SPEED_CHANGING_LAYER
SET_VELOCITY_LIMIT ACCEL=12000 ACCEL_TO_DECEL=9600 SQUARE_CORNER_VELOCITY=12
G1 E-.8 F2400
G1 X60 Y${yStep} F30000
G1 Z${z}
G1 E.8 F2400\n`;
  } else {
    if (layerIndex === 2) {
      gcode += `M106 S255
M106 P2 S255
M140 S55 ; set bed temperature\n`;
    }

    gcode += `;LAYER_CHANGE
;Z:${currentLayerHeight}
;HEIGHT:${layerHeight}
;BEFORE_LAYER_CHANGE
;${currentLayerHeight}
G92 E0

;_SET_FAN_SPEED_CHANGING_LAYER
SET_VELOCITY_LIMIT ACCEL=12000 ACCEL_TO_DECEL=9600 SQUARE_CORNER_VELOCITY=12
G1 X60 Y${yStep} F30000
G1 Z${z}
G1 E.8 F2400\n`;   
  }

  for (let lineIndex = 1; lineIndex <= numLines; lineIndex++) {
    const y = yStep * lineIndex;
    gcode += `; line #${lineIndex}\n`;

    if (lineIndex > 1) {
      gcode += `SET_VELOCITY_LIMIT ACCEL=12000 ACCEL_TO_DECEL=9600 SQUARE_CORNER_VELOCITY=12
G1 X60 Y${y} F30000\n`;
    }

    gcode += `SET_VELOCITY_LIMIT ACCEL=${accel} ACCEL_TO_DECEL=${accelToDecel} SQUARE_CORNER_VELOCITY=8
; first segment
SET_PRESSURE_ADVANCE ADVANCE=${slowPA}; Override pressure advance value
G1 F${slowFlow}
G1 X80.5 Y${y} E${slowExtrusion}
; middle segment
SET_PRESSURE_ADVANCE ADVANCE=${fastPA}; Override pressure advance value
G1 F${fastFlow}
G1 X139.5 Y${y} E${fastExtrusion}
; last segment
SET_PRESSURE_ADVANCE ADVANCE=${slowPA}; Override pressure advance value
G1 F${slowFlow}
G1 X160 Y${y} E${slowExtrusion}\n`;
    
    if (firstLayerPA || layerIndex > 1) {
      fastPA += fastPaStep;
      slowPA += slowPaStep;
    }
  }
  
  gcode += `G1 E-.8 F2400\n`;
}

gcode += `M106 S0
M106 P2 S0
;TYPE:Custom
; filament end gcode
END_PRINT
M73 P100 R0
; EXECUTABLE_BLOCK_END`;

writeFileSync("pa-line.gcode", gcode);