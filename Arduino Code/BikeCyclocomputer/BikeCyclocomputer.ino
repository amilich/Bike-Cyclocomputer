#define baudRate  9600
#define magSensorPin  0; //Pin 2 (interrupt 0)
#define magPin_PIN      PIND
#define LED  13

#include <LiquidCrystal.h>

int lastState = LOW; 
int magCount = 0; 
int magState; 
float wheelSize; 
double speedMPH; 

unsigned long time = 0;
long timeDelay = 50;
float inTime; 
long oldTime;
int wheelCount = 0; 
int wheelTotal; 

LiquidCrystal lcd(12, 11, 7, 6, 5, 4);

void setup(){
  magState = digitalRead(2); 
  Serial.begin(9600); 
  pinMode(LED, 13); 
  lcd.begin(16, 2);
  attachInterrupt(0, senseMag, CHANGE);
}

void  loop(){ 
  if(magState != lastState && magState == HIGH){
    inTime = millis() - oldTime;  
  }
  if(digitalRead(2) == LOW){
    magState = LOW;  
  }

  if (magState == HIGH) {
    digitalWrite(LED, HIGH);
    if (lastState != HIGH){
      lastState = HIGH;
      magCount++; 
      oldTime = millis(); 
    }
  } 
  else {
    digitalWrite(LED, LOW);
    if (lastState != LOW && millis() - time > timeDelay)
      lastState = LOW;
    time = millis();   
  }


  if(Serial.available() >= 0 && speedMPH <= 25) {
    Serial.print(speedMPH);
    Serial.flush();
    Serial.print(","); 
    Serial.print(magCount*wheelSize*2*PI);
    Serial.flush();
    Serial.print(","); 
    Serial.println(analogRead(0)); 
    Serial.flush(); 
  }
  if(inTime >= 100)
    speedMPH = 2*wheelSize*PI*3600000/5280/inTime;  
  if(millis() <= 15000){
    wheelSize = analogRead(0); 
    wheelSize = wheelSize/300; 
    lcd.setCursor(0, 0); 
    lcd.print(15 - int(millis()/1000)); 
    lcd.print(" sec to set."); 
    lcd.setCursor(0, 1); 
    lcd.print("Radius: "); 
    lcd.print(double(wheelSize)); 
    lcd.print("ft."); 
    wheelCount ++; 
  }
  else {
    lcd.setCursor(0, 0); 
    lcd.print("Speed: "); 
    lcd.print(speedMPH); 
    lcd.print("mph.");
  }
  delay(10); 
  lcd.clear(); 
}

void senseMag(){
  if(magState == LOW)
    magState = HIGH;  
  else
    magState = LOW; 
}





