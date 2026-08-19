#include <LiquidCrystal.h> // LCD Header

LiquidCrystal lcd(7, 6, 5, 4, 3, 2); // Pins for LCD Connection

#define buzzer 12
#define led 13

#define x A0
#define y A1
#define z A2

/* Variables */
long xsample = 0;
long ysample = 0;
long zsample = 0;
long start;
int buz = 0;

/* Macros */
#define samples 50
#define maxVal 20
#define minVal -20
#define buzTime 5000

void setup() {
  lcd.begin(16, 2);
  Serial.begin(9600);

  delay(1000);

  lcd.print("Vibration ");
  lcd.setCursor(0, 1);
  lcd.print("Detector");
  delay(2000);

  lcd.clear();
  lcd.print("Calibrating.....");
  lcd.setCursor(0, 1);
  lcd.print("Please wait...");

  pinMode(buzzer, OUTPUT);
  pinMode(led, OUTPUT);

  buz = 0;
  digitalWrite(buzzer, buz);
  digitalWrite(led, buz);

  // Taking samples for calibration
  for (int i = 0; i < samples; i++) {
    xsample += analogRead(x);
    ysample += analogRead(y);
    zsample += analogRead(z);
    delay(10);
  }

  // Taking average
  xsample /= samples;
  ysample /= samples;
  zsample /= samples;

  delay(3000);

  lcd.clear();
  lcd.print("Calibrated");
  delay(1000);

  lcd.clear();
  lcd.print("Device Ready");
  delay(1000);

  lcd.clear();
  lcd.print(" X   Y   Z ");
}

void loop() {

  // Reading accelerometer values
  int value1 = analogRead(x);
  int value2 = analogRead(y);
  int value3 = analogRead(z);

  // Finding change from calibrated values
  int xValue = xsample - value1;
  int yValue = ysample - value2;
  int zValue = zsample - value3;

  // Displaying values on LCD
  lcd.setCursor(0, 1);
  lcd.print("                ");

  lcd.setCursor(0, 1);
  lcd.print(xValue);

  lcd.setCursor(6, 1);
  lcd.print(yValue);

  lcd.setCursor(12, 1);
  lcd.print(zValue);

  // Checking vibration threshold
  if (xValue < minVal || xValue > maxVal ||
      yValue < minVal || yValue > maxVal ||
      zValue < minVal || zValue > maxVal) {

    if (buz == 0) {
      start = millis();
    }

    buz = 1;

    lcd.setCursor(0, 0);
    lcd.print("VIBRATION ALERT ");
  }

  else if (buz == 1 && millis() >= start + buzTime) {

    buz = 0;

    lcd.setCursor(0, 0);
    lcd.print(" X   Y   Z       ");
  }

  // Buzzer and LED control
  digitalWrite(buzzer, buz);
  digitalWrite(led, buz);

  // Sending data to Processing
  Serial.print("x=");
  Serial.println(xValue);

  Serial.print("y=");
  Serial.println(yValue);

  Serial.print("z=");
  Serial.println(zValue);

  Serial.println(" $");
}