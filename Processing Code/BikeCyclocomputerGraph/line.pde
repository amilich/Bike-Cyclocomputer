public class myLine {
  int x; 
  int y; 
  int xEnd; 
  float yEnd; 
  float redCol, greenCol, blueCol; 
  myLine() {
    x = count; 
    y = height - graphYIndent; 
    xEnd = count;
    yEnd = height - graphYIndent - map(speed, 0, 25, 0, 300);
    if (speed >= 10) 
      redCol = map(speed, 0, 25, 0, 255);
    else
      redCol = 20; 
    greenCol = speed*2; 
    if (speed <= 10) 
      blueCol = map(speed, 0, 25, 0, 255);
    else 
      blueCol = 20;
  }

  void drawLine() {
    stroke(redCol, greenCol, blueCol); 
    line(x, y, xEnd, yEnd);
  }
}

