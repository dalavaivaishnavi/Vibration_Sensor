import processing.serial.*;

PFont f6, f8, f10, f12, f24;
Serial myPort;

int xPos = 0;
float y1 = 0;
float y2 = 0;
float y3 = 0;

void setup() {

  // Font sizes
  f6 = createFont("Arial", 6, true);
  f8 = createFont("Arial", 8, true);
  f10 = createFont("Arial", 10, true);
  f12 = createFont("Arial", 12, true);
  f24 = createFont("Arial", 24, true);

  size(1200, 700);

  // Display available serial ports
  println(Serial.list());

  // Change COM10 to your Arduino's actual COM port
  myPort = new Serial(this, "COM10", 9600);

  println(myPort);

  // Read data until '$'
  myPort.bufferUntil('$');

  background(80);
}

void draw() {
  handleSerial();
}

void handleSerial() {

  String inString = myPort.readStringUntil('$');

  if (inString != null) {

    try {

      // Extract X value
      int l1 = inString.indexOf("x=") + 2;
      String temp1 = inString.substring(
        l1,
        inString.indexOf('\n', l1)
      );

      // Extract Y value
      l1 = inString.indexOf("y=") + 2;
      String temp2 = inString.substring(
        l1,
        inString.indexOf('\n', l1)
      );

      // Extract Z value
      l1 = inString.indexOf("z=") + 2;
      String temp3 = inString.substring(
        l1,
        inString.indexOf('\n', l1)
      );

      // Convert values
      float inByte1 = float(temp1.trim());
      float inByte2 = float(temp2.trim());
      float inByte3 = float(temp3.trim());

      // Map values to graph
      inByte1 = map(inByte1, -80, 80, 0, height - 80);
      inByte2 = map(inByte2, -80, 80, 0, height - 80);
      inByte3 = map(inByte3, -80, 80, 0, height - 80);

      float x = map(
        xPos,
        0,
        1120,
        40,
        width - 40
      );

      // Background
      background(80);

      // Title
      textFont(f24);
      fill(0, 0, 255);
      textAlign(CENTER);

      text(
        "Vibration Graph",
        width / 2,
        50
      );

      // Display values
      textFont(f12);

      fill(0, 0, 255);
      text("X: " + temp1, 100, 95);

      fill(0, 255, 0);
      text("Y: " + temp2, 100, 120);

      fill(255, 0, 0);
      text("Z: " + temp3, 100, 145);

      // Graph
      strokeWeight(2);

      int shift = 40;

      // X axis
      stroke(0, 0, 255);

      if (y1 == 0) {
        y1 = height - inByte1 - shift;
      }

      line(
        x,
        y1,
        x + 2,
        height - inByte1 - shift
      );

      y1 = height - inByte1 - shift;

      // Y axis
      stroke(0, 255, 0);

      if (y2 == 0) {
        y2 = height - inByte2 - shift;
      }

      line(
        x,
        y2,
        x + 2,
        height - inByte2 - shift
      );

      y2 = height - inByte2 - shift;

      // Z axis
      stroke(255, 0, 0);

      if (y3 == 0) {
        y3 = height - inByte3 - shift;
      }

      line(
        x,
        y3,
        x + 2,
        height - inByte3 - shift
      );

      y3 = height - inByte3 - shift;

      // Move graph position
      xPos += 2;

      // Reset graph
      if (x >= width - 40) {

        xPos = 0;
        background(80);
      }

    }

    catch (Exception e) {

      println(
        "Error parsing serial data: "
        + e.getMessage()
      );
    }
  }
}