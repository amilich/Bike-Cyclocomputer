import processing.serial.*; 
float data1, data2; 
boolean started = false; 
int screenNum = 0; //0: graph. 1: help. 
int countMultiplier = 1; 
float topSpeed = 0; 

PrintWriter writer;
BufferedReader reader;
String title = "myTrip"; 
float speed; 
Serial port;
PFont speedFont, buttonFont; 
button helpButton; 
int textY = 30; 
int graphYIndent = 80; 
int graphXIndent = 60; 
myLine[] lineGraph = new myLine[100000];  
int count = 70; 
int oldCount; 
int serialConnected = 2; 
button[] serialButtons = new button[Serial.list().length]; 

void setup() {
  cursor(CROSS); 
  frameRate(18); 
  size(screen.width - 150, screen.height - 100); 
  speedFont = loadFont("Serif.bold-20.vlw"); 
  buttonFont = loadFont("SegoePrint-Bold-16.vlw"); 
  title = title + " " + month() + "-" + day() + "-" + year() + ".txt"; 
  writer = createWriter(title ); 
  writer.println("Your trip: "); 
  writer.flush();
  try {
    String connection = Serial.list()[2]; 
    port = new Serial(this, connection, 9600);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  println(Serial.list());
  delay(2000); 
  helpButton = new button(100, 40);
  for (int ii = 0; ii < lineGraph.length; ii++) {
    lineGraph[ii] = new myLine();
  }
  for (int qq = 0; qq < serialButtons.length; qq++) {
    serialButtons[qq] = new button();
  }
}

void draw() {
  if (count%10 == 0) {
    writer.println("\n Time: " + hour()+":"+minute()+":"+second()+". "+"Speed: "+speed+ " mph."); 
    writer.flush();
  }
  background(140); 
  lineGraph[count*countMultiplier] = new myLine();
  if (screenNum == 0) {
    helpButton.show("help", width-100, textY, true);
    fill(255); 
    textFont(buttonFont, 13); 
    for (int qq = height - graphYIndent; qq >= graphYIndent; qq-=40) {
      line(graphXIndent, qq, width - 30, qq);
    }
    graphYIndent = 80; 
    text("Time (sec)", width/2, height - graphYIndent/2); 
    for (int qq = graphXIndent; qq <= width; qq += 40) {
      line(qq, height - graphYIndent, qq, graphYIndent);
    } 
    for (int ii = 0; ii < count; ii ++) {
      lineGraph[ii*countMultiplier].drawLine();
    }
  }
  else if (screenNum == 1) {
    text("Available Serial Ports: ", graphXIndent, 80);
    line(graphXIndent, 85, graphXIndent + 200, 85);  
    helpButton.show("return", width-100, textY, true);
    try {
      text("Connected", serialButtons[serialConnected].buttonX + serialButtons[serialConnected].xLength, serialButtons[serialConnected].buttonY);
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    for (int qq = 0; qq < serialButtons.length; qq++) {
      serialButtons[qq].show(Serial.list()[qq], graphXIndent, qq*40 + 150, false);
      if (serialButtons[qq].checkPress() && mousePressed) {
        cursor(WAIT);
        try {
          String connection = Serial.list()[qq]; 
          port = new Serial(this, connection, 9600);
          serialConnected = qq;
        }
        catch(Exception e) {
          e.printStackTrace();
        }
      }
      else if (serialButtons[qq].checkPress()) {
        cursor(HAND);
      }
      else {
        cursor(ARROW);
      }
    }
  }
  textFont(speedFont); 
  fill(255); 
  speed = data1;
  text("Current speed: " + speed, 40, textY);
  text("Distance traveled: " + data2 + " feet.", 40, textY + 25);
  text("Top Speed: " + topSpeed + "mph.", 300, textY);  
  if (helpButton.checkPress() && mousePressed) {
    cursor(WAIT);

    if (screenNum == 0 && mousePressed) {
      screenNum = 1; 
      delay(100);
    }
    else if (screenNum == 1 && mousePressed) {
      screenNum = 0;
      delay(100);
    }
  }
  else if (helpButton.checkPress()) {
    cursor(HAND);
  }
  else {
    cursor(ARROW);
  }

  if (count <= lineGraph.length) {
    count++;
  }
  if (count == width) {
    count = 70;
    countMultiplier = 2;
  }
  
  if(speed > topSpeed){
   topSpeed = speed; 
   writer.println("Top speed: " + speed);  
  }
}

void keyPressed() { 
  if (key == 's') {
    writer.flush(); 
    writer.close(); 
    exit();
    println("close");
  }
}

void serialEvent(Serial port) { 
  String inString = port.readStringUntil('\n');
  if (inString != null) {
    inString.trim();
    started = true; 
    float[] data = float(split(inString, ","));
    if (data.length > 2) {
      data1 = data[0]; 
      data2 = data[1]; 
      port.clear();
    }
  }
}

