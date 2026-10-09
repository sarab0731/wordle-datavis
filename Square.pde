class Square {
  int size;
  color colour;
  String score;
  float hoverScale , xPos, yPos;

  Square(float xPos, float yPos, int size, color colour, String score)
  {
    this.xPos = xPos;
    this.yPos = yPos;
    this.size = size;
    this.colour = colour;
    this.score = score;
    this.hoverScale = 1.0;
  }

  void display() {
    noStroke();
    fill(colour);
    rect(xPos, yPos, size, size);

    fill(255); // white text
    textAlign(CENTER, CENTER);
    textFont(franklin_gothic);
    text(score, xPos + size / 2, yPos + size / 2);
  }


  void hoverDisplay() {
    // empty day entries will not have a hover display
    if (cursorOverlapsWith() && !score.equals("")) {
      hoverScale = min(hoverScale +0.01, 1.03);
    } else {
      hoverScale = max(hoverScale -0.005, 1.0);
    }

    float animatedSize = size * hoverScale;
    float offset = (animatedSize - size) / 2; // offset to keep square centered

    fill(colour);
    rect(xPos - offset, yPos - offset, animatedSize, animatedSize);

    fill(255); // white text
    textAlign(CENTER, CENTER);
    textFont(franklin_gothic,47);
    text(score, xPos + size / 2, yPos + size / 2);
  }

  void clickedDisplay() {
    // Display the square with a highlighted effect when clicked
    noStroke();
    fill(colour);
    rect(xPos, yPos, size, size);

    fill(255); // White text
    textAlign(CENTER, CENTER);
    textFont(franklin_gothic);
    text(score, xPos + size / 2, yPos + size / 2);

    fill(255, 255, 255, 100); // Add some transparency for effect
    rect(xPos, yPos, size, size); // Highlight the square 
  }
  
void minigameDisplay(color[] colours) {
    noStroke();
    
    int columns = 2; // Number of columns in the grid (adjust as needed)
    float xStart = xPos; // Starting X position for the grid
    float yStart = yPos; // Starting Y position for the grid
    int counter = 0;  // Keep track of the current rectangle index
    fill(120, 124, 127);
    rect(xPos, yPos, size-2, size-2);
    
    for (color minigame : colours) {
        fill(minigame);
        float xPos = xStart + (counter % columns) * (size / 2 ); // Calculate X based on column
        float yPos = yStart + (counter / columns) * (size / 2 ); // Calculate Y based on row
        rect(xPos, yPos, size / 2, size / 2);
        counter++;
    }

    // Display the score in the center of the grid
    fill(255); // White text
    textAlign(CENTER, CENTER);
    textFont(franklin_gothic,47);
    text(score, xStart + (size / 2), yStart + (size / 2));
}

  
  
  void timeDisplay(){
    // method to display time values 
  }

  
  boolean cursorOverlapsWith() {
    // Check if the mouse cursor is within the bounds of this square
    return mouseX >= xPos && mouseX <= xPos + size &&
      mouseY >= yPos && mouseY <= yPos + size;
  }
  
}
