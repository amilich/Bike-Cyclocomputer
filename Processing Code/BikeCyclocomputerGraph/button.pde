public class button
{
  int xLength, yLength, zLength; 
  int xCol = 255; 
  int buttonX, buttonY; 
  float rotateXPos = 0; 
  float rotateYPos = 0; 
  boolean pressed = false; 
  boolean goToWhite = true;
  String name;  

  button() {
    xLength = 100; 
    yLength = 50;
  }

  button(int x, int y) {
    xLength = x; 
    yLength = y;
  }

  void show(String n, int xPos, int yPos, boolean changeCol) {
    stroke(255); 
    strokeWeight(1);  
    noFill(); 
    if (!checkPress() && changeCol) {
      if (goToWhite) {
        xCol += 10;
        if (xCol > 240) {
          goToWhite = false;
        }
      }
      else if (!goToWhite) {
        xCol -= 10;
        if (xCol <= 20) {
          goToWhite = true;
        }
      }
    }
    name = n; 
    fill(xCol); 
    textFont(buttonFont, 25); 
    text(n, xPos, yPos);
    buttonX = xPos; 
    buttonY = yPos;
  }

  boolean checkPress() {
    if (mouseX > buttonX && mouseX <= buttonX + xLength && mouseY >= buttonY - 40 
      && mouseY <= buttonY + yLength) {
      xCol = color(255);  
      return true;
    }
    else {
      return false;
    }
  }
}

