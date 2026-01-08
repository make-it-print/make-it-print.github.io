import { writeFileSync } from "node:fs"

const extruderTemp = 240;
const bedTemp = 80;
const isFirstLayerPaTest = false;
const zOffset = 0.01;
let layerHeight = 0.4;
const firstLayerPa = 0.02;

const yStep = 10;
const numLines = 20;
const numLayers = isFirstLayerPaTest ? 1 : 8;
const lineWidth = 0.84;
const wallCount = 3;

const paStartValue = 0.0; // 0.03
const paEndValue = 0.04;
const paStep = (paEndValue - paStartValue) / numLines;

const retractionSettinsgs = {
  length: 0.8,
  speed: 2400,
}

const line20mm = {
  extrusion: 2.28284,
  length: 20
};

const line40mm = {
  extrusion: 4.66577,
  length: 40
};

const line50mm = {
  extrusion: 5.85723,
  length: 50
};

const geometry = {
  short: line50mm,
  long: line50mm,
}

const firstLayerSettings = {
  accel: 500,
  accelToDecel: 125,
  squareCornerVelocity: 5,
  short: {
    pa: isFirstLayerPaTest ? paStartValue : firstLayerPa,
    flow: 7200,
  },
  long: {
    pa: isFirstLayerPaTest ? paStartValue : firstLayerPa,
    flow: 7200,
  }
}

const lineSettings = [
  // Basic PA tests
  //{
  //  // 80mm/s, 0.82lw
  //  accel: 5000,
  //  accelToDecel: 1250,
  //  squareCornerVelocity: 1,
  //  short: {
  //    pa: paStartValue,
  //    testPa: true,
  //    flow: 4800,
  //  },
  //  long: {
  //    pa: paStartValue,
  //    testPa: true,
  //    flow: 4800,
  //  }
  //}
  // {
  //   // 80mm/s, 1.16lw
  //   accel: 5000,
  //   accelToDecel: 1250,
  //   squareCornerVelocity: 1,
  //   short: {
  //     pa: paStartValue,
  //     testPa: true,
  //     flow: 4800,
  //   },
  //   long: {
  //     pa: paStartValue,
  //     testPa: true,
  //     flow: 4800,
  //   }
  // }
  //{
  //  // 60mm/s, 0.84lw
  //  accel: 5000,
  //  accelToDecel: 1250,
  //  squareCornerVelocity: 1,
  //  short: {
  //    pa: paStartValue,
  //    testPa: true,
  //    flow: 3600,
  //  },
  //  long: {
  //    pa: paStartValue,
  //    testPa: true,
  //    flow: 3600,
  //  }
  //}
  //{
  //  // 35mm/s, 0.84lw
  //  accel: 5000,
  //  accelToDecel: 1250,
  //  squareCornerVelocity: 1,
  //  short: {
  //    pa: paStartValue,
  //    testPa: true,
  //    flow: 2100,
  //  },
  //  long: {
  //    pa: paStartValue,
  //    testPa: true,
  //    flow: 2100,
  //  }
  //}
  // {
  //   // 15mm/s, 0.84lw
  //   accel: 5000,
  //   accelToDecel: 1250,
  //   squareCornerVelocity: 1,
  //   short: {
  //     pa: paStartValue,
  //     testPa: true,
  //     flow: 900,
  //   },
  //   long: {
  //     pa: paStartValue,
  //     testPa: true,
  //     flow: 900,
  //   }
  // }
  // {
  //   // 35-80-35mm/s, 0.82lw
  //   accel: 5000,
  //   accelToDecel: 1250,
  //   squareCornerVelocity: 1,
  //   short: {
  //     pa: paStartValue,
  //     testPa: true,
  //     flow: 2100,
  //   },
  //   long: {
  //     pa: 0.02999,
  //     testPa: false,
  //     flow: 4800,
  //   }
  // }
  // {
  //   // 35-80-35mm/s, 0.82lw
  //   accel: 5000,
  //   accelToDecel: 1250,
  //   squareCornerVelocity: 1,
  //   short: {
  //     pa: 0,
  //     testPa: false,
  //     flow: 600,
  //   },
  //   long: {
  //     pa: 0.02999,
  //     testPa: true,
  //     flow: 4800,
  //   }
  // }
  {
    // 35-80-35mm/s, 0.82lw
    accel: 5000,
    accelToDecel: 1250,
    squareCornerVelocity: 1,
    short: {
      pa: paStartValue,
      testPa: true,
      flow: 4800,
    },
    long: {
      pa: paStartValue,
      testPa: true,
      flow: 4800,
    }
  }
];

const geometryOffset = [
  {
    x: 30,
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
      if (lineSettings[columnIndex].short.testPa === true)
        lineSettings[columnIndex].short.pa = paStartValue;

      if (lineSettings[columnIndex].long.testPa === true)
        lineSettings[columnIndex].long.pa = paStartValue;
    }
  }

  if (isFirstLayerPaTest) {
    if (lineSettings[columnIndex].short.testPa === true)
      firstLayerSettings.short.pa = paStartValue;

    if (lineSettings[columnIndex].long.testPa === true)
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
G1 X${geometryOffset[columnIndex].x + geometry.short.length} Y${y + geometryOffset[columnIndex].y} E${geometry.short.extrusion}
; middle segment
SET_PRESSURE_ADVANCE ADVANCE=${currentSettings.long.pa}; Override pressure advance value
G1 F${currentSettings.long.flow}
G1 X${geometryOffset[columnIndex].x + geometry.short.length + geometry.long.length} Y${y + geometryOffset[columnIndex].y} E${geometry.long.extrusion}
; last segment
SET_PRESSURE_ADVANCE ADVANCE=${currentSettings.short.pa}; Override pressure advance value
G1 F${currentSettings.short.flow}
G1 X${geometryOffset[columnIndex].x + geometry.short.length * 2 + geometry.long.length} Y${y + geometryOffset[columnIndex].y} E${geometry.short.extrusion}\n`;
    }

    if (layerIndex > 1) {
      for (let columnIndex = 0; columnIndex < geometryOffset.length; columnIndex++) {
        if (lineSettings[columnIndex].short.testPa === true)
          lineSettings[columnIndex].short.pa += paStep;

        if (lineSettings[columnIndex].long.testPa === true)
          lineSettings[columnIndex].long.pa += paStep;
      }
    }

    if (isFirstLayerPaTest) {
      if (lineSettings[columnIndex].short.testPa === true)
        firstLayerSettings.short.pa += paStep;

      if (lineSettings[columnIndex].long.testPa === true)
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