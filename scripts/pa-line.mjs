import { writeFileSync } from "node:fs"

const extruderTemp = 230;
const bedTemp = 60;
const isFirstLayerPaTest = false;
const zOffset = 0.1;
let layerHeight = 0.2;
const firstLayerPa = 0.05312;

const yStep = 10;
const numLines = 20;
const numLayers = isFirstLayerPaTest ? 1 : 12*2;

const paStartValue = 0.0; // 0.03
const paEndValue = 0.05;
const paStep = (paEndValue - paStartValue) / numLines;

const retractionSettinsgs = {
  length: 0.5,
  speed: 1800,
}

const lineSettings = [
  {
    // 30mm/s
    accel: 5000,
    accelToDecel: 2500,
    squareCornerVelocity: 9,
    short: {
      pa: paStartValue,
      extrusion: 0.92324,
      flow: 30000,
    },
    long: {
      pa: paStartValue,
      extrusion: 2.64319,
      flow: 30000,
    }
  },
  {
    // 10mm/s
    accel: 5000,
    accelToDecel: 2500,
    squareCornerVelocity: 9,
    short: {
      pa: paStartValue,
      extrusion: 0.6888,
      flow: 600,
    },
    long: {
      pa: paStartValue,
      extrusion: 1.98239,
      flow: 600,
    }
  }
];

const firstLayerSettings = {
  accel: 2000,
  accelToDecel: 1000,
  squareCornerVelocity: 9,
  short: {
    pa: isFirstLayerPaTest ? paStartValue : firstLayerPa,
    extrusion: 0.92324,
    flow: 3600,
  },
  long: {
    pa: isFirstLayerPaTest ? paStartValue : firstLayerPa,
    extrusion: 2.64319,
    flow: 3600,
  }
}

const geometryOffset = [
  {
    x: 9,
    y: 0
  }
  //,
  //{
  //  x: 60,
  //  y: 5
  //}
  //,{
  //  x: 111,
  //  y: 0
  //}
]


let gcode = `; EXECUTABLE_BLOCK_START
M73 P0 R0
M106 S0
M106 P2 S0
;TYPE:Custom
M140 S0
M104 S0
START_PRINT EXTRUDER_TEMP=${extruderTemp} BED_TEMP=${bedTemp}
SET_PRESSURE_ADVANCE SMOOTH_TIME=0.02
G90
G21
M83 ; use relative distances for extrusion
; Filament gcode
; SET_GCODE_OFFSET Z=xxx
; z_offset xxx ???
SET_PRESSURE_ADVANCE ADVANCE=0.03; Override pressure advance value
`;


for (let layerIndex = 1; layerIndex <= numLayers; layerIndex++) {
  const z = (layerHeight * layerIndex + zOffset).toFixed(2);
  const currentLayerHeight = (layerHeight * layerIndex).toFixed(2);
  
  if (layerIndex === 1) {
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
G1 E-${retractionSettinsgs.length} F${retractionSettinsgs.speed}
G1 X${geometryOffset[0].x} Y${yStep + geometryOffset[0].y} F30000
G1 Z${z}
G1 E${retractionSettinsgs.length} F${retractionSettinsgs.speed}\n`;
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
G1 X${geometryOffset[0].x} Y${yStep + geometryOffset[0].y} F30000
G1 Z${z}
G1 E${retractionSettinsgs.length} F${retractionSettinsgs.speed}\n`;   
  }

  if (layerIndex > 1) {
    for (let columnIndex = 0; columnIndex < geometryOffset.length; columnIndex++) {
      lineSettings[columnIndex].short.pa = paStartValue;
      lineSettings[columnIndex].long.pa = paStartValue;
    }
  }

  if (isFirstLayerPaTest) {
    firstLayerSettings.short.pa = paStartValue;
    firstLayerSettings.long.pa = paStartValue;
  }

  for (let rowIndex = 1; rowIndex <= numLines; rowIndex++) {
    const y = yStep * rowIndex;
    gcode += `; line #${rowIndex}\n`;

    for (let columnIndex = 0; columnIndex < geometryOffset.length; columnIndex++) {
      const currentSettings = layerIndex === 1 ? firstLayerSettings : lineSettings[columnIndex];

      if (rowIndex > 1 || columnIndex > 0) {
        gcode += `SET_VELOCITY_LIMIT ACCEL=12000 ACCEL_TO_DECEL=9600 SQUARE_CORNER_VELOCITY=12
G1 X${geometryOffset[columnIndex].x} Y${y + geometryOffset[columnIndex].y} F30000\n`;
      }

      gcode += `SET_VELOCITY_LIMIT ACCEL=${currentSettings.accel} ACCEL_TO_DECEL=${currentSettings.accelToDecel} SQUARE_CORNER_VELOCITY=${currentSettings.squareCornerVelocity}
; first segment
SET_PRESSURE_ADVANCE ADVANCE=${currentSettings.short.pa}; Override pressure advance value
G1 F${currentSettings.short.flow}
G1 X${geometryOffset[columnIndex].x + 20.5} Y${y + geometryOffset[columnIndex].y} E${currentSettings.short.extrusion}
; middle segment
SET_PRESSURE_ADVANCE ADVANCE=${currentSettings.long.pa}; Override pressure advance value
G1 F${currentSettings.long.flow}
G1 X${geometryOffset[columnIndex].x + 79.5} Y${y + geometryOffset[columnIndex].y} E${currentSettings.long.extrusion}
; last segment
SET_PRESSURE_ADVANCE ADVANCE=${currentSettings.short.pa}; Override pressure advance value
G1 F${currentSettings.short.flow}
G1 X${geometryOffset[columnIndex].x + 100} Y${y + geometryOffset[columnIndex].y} E${currentSettings.short.extrusion}\n`;
    }

    if (layerIndex > 1) {
      for (let columnIndex = 0; columnIndex < geometryOffset.length; columnIndex++) {
        lineSettings[columnIndex].short.pa += paStep;
        lineSettings[columnIndex].long.pa += paStep;
      }
    }

    if (isFirstLayerPaTest) {
      firstLayerSettings.short.pa += paStep;
      firstLayerSettings.long.pa += paStep;
    }
  }
  
  gcode += `G1 E-${retractionSettinsgs.length} F${retractionSettinsgs.speed}\n`;
}

gcode += `M106 S0
M106 P2 S0
;TYPE:Custom
; filament end gcode
END_PRINT
M73 P100 R0
; EXECUTABLE_BLOCK_END`;

writeFileSync("pa-line.gcode", gcode);