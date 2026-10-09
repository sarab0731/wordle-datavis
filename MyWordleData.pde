/*Digitized data copyright The Monotype Corporation 1991-1995. All rights reserved.
 Franklin Gothic is a trademark of The International Typeface Corporation which may
 be registered in certain jurisdictions.*/
PFont franklin_gothic;                //Franklin Gothic Demi font
PFont news_gothic;                    // News Gothis Std medium font

int[] days, scores;                   // Array to store day & score values
float[] times;                        // Array to store times
String[] locations, strScores;        // Array to store location data & the scores as Strings
String[][] minigames;                 // 2D Array to store extra minigames played

color[] sColours;                     // Array to store the colours of the squares depending on whether I completed the wordle or not
color[][] mgColours;                  // 2D array of minigame colours to represent each minigame played per day

int cols = 7;                         // Number of columns
int rows = 8;                         // Number of rows
int squareSize = 75;                  // Size of each square
int spacing = 8;                      // Spacing between squares
float startX = 313.5;                 // X-coordinate of the grids TL corner
float startY = 50;                    // Y-coordinate of the grids TL corner

Square[] s;
String highlightedScore = null;       // To track the score of the clicked square
boolean showMinigame = false;         // Track whether to show the minigame grid


void setup() {
  size(1200, 750);
  franklin_gothic = createFont("franklingothic_demi.ttf", 45);
  news_gothic = createFont("News Gothic Std Medium.otf", 18);

  loadAndProcessData();
  createGrid();
}

void draw() {
  background(255);
  displayInstructions();

  if (showMinigame) {
    displayMinigameGrid();
  } else {
    displayMainGrid();
  }
}

void mousePressed() {
  for (Square square : s) {
    // Check if the mouse overlaps and the score is valid
    if (square.cursorOverlapsWith() && square.score != null) {
      highlightedScore = square.score; // score to be highlighted
      break;
    } else {
      highlightedScore = null;
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    highlightedScore = null;
    showMinigame = false; // remove minigame grid
  }
  if (key == 'm') {
    showMinigame = true; // Switch to the minigame grid
  }
  if (key == 'l') {
  }
  if (key == 't') {
  }
}

void loadAndProcessData() {
  /* --loading & storing data-- */

  // Load data from wordleData.txt file
  String[] textLines = loadStrings("wordleData.txt");
  // Create arrays for the data sized according to number of lines
  int dataLength = textLines.length;
  days       = new int[dataLength];
  scores     = new int[dataLength];
  times      = new float[dataLength];
  locations  = new String[dataLength];
  minigames  = new String[dataLength][];
  mgColours  = new color[dataLength][];

  sColours = new color[dataLength]; // Initialize color array
  strScores= new String[dataLength];

  color darkGrey = color(120, 124, 127), yellow = color(203, 184, 69), green = color(82, 176, 94);

  // iterate and store day, score, time, location and minigame per day
  for (int i=0; i<dataLength; i++)
  {
    // Split the line into 'values' array separated by "|"
    String[] values = split(textLines[i], "|");

    days[i]       = int(values[0]);
    scores[i]     = int(values[1]);
    times[i]      = float(values[2]);
    locations[i]  = values[3].toLowerCase();
    minigames[i] = split(values[4].toLowerCase(), ",");

    sColours[i] = assignSquareColour(scores[i], darkGrey, yellow, green);
    strScores[i] = assignScoreText(scores[i]);

    // assign minigame colours
    if (minigames[i] != null) {
      mgColours[i] = new color[4];
      for (int j = 0; j < 4; j++) {
        if (j < minigames[i].length && minigames[i][j] != null) {
          mgColours[i][j] = assignMinigameColour(minigames[i][j]);
        } else {
          mgColours[i][j] = color(120, 124, 127);
        }
      }
    }
  }
}

void createGrid() {
  s = new Square[cols * rows];  // Initialize square array
  /* --CREATING GRID LOOP-- */
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      // Calculate x and y positions for each square
      float x = startX + col * (squareSize + spacing);
      float y = startY + row * (squareSize + spacing);
      // Calculate the i value of current square to determine square colour and score
      int i = row* cols + col;

      if (i < sColours.length && sColours[i] != 0) { // Prevent accessing out of bounds
        s[i] = new Square(x, y, squareSize, sColours[i], strScores[i]);
      } else {
        s[i] = new Square(x, y, squareSize, color(255), ""); // Default color for empty squares
      }
    }
  }
}

void displayInstructions() {
  fill(5);
  textAlign(LEFT);
  textFont(news_gothic, 14);
  text("To view the minigames played per day, press M", 905, 610);
  text("To reset the grid, press R", 905, 628);
}

void displayMainGrid() {
  for (Square square : s) {
    if (square != null) {
      if (highlightedScore != null && !square.score.equals(highlightedScore)) {
        square.clickedDisplay(); // Highlight matching squares
      } else {
        square.display(); // Display the normal grid
        square.hoverDisplay(); // Apply hover effect if applicable
      }
    }
  }
}

void displayMinigameGrid() {
  for (int i = 0; i < s.length; i++) {
    if (s[i] != null && mgColours[i] != null) {
      s[i].minigameDisplay(mgColours[i]); // Display the minigame grid
    }
  }
}

color assignSquareColour(int score, color darkGrey, color yellow, color green) {
  switch (score) {
  case -1:
    return darkGrey;
  case 0:
    return yellow;
  case 1:
  case 2:
  case 3:
  case 4:
  case 5:
  case 6:
    return green;
  default:
    return color(255); // Default to white if score is invalid
  }
}

String assignScoreText(int score) {
  if (score >= 0 && score <= 6) return str(score);
  return score == -1 ? "" : null;
}

color assignMinigameColour(String minigame) {
  switch (minigame) {
  case "connections":
    return color(186, 159, 255);
  case "sudoku":
    return color(255, 154, 0);
  case "mini":
    return color(144, 187, 255);
  case "strands":
    return color(186, 223, 218);
  default:
    return color(120, 124, 127);
    //return color(211, 214, 219);
  }
}
