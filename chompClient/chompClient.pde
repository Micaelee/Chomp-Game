//CHOMP - CLIENT -- run after server

/*Try to eat as many donuts and tacos as possible but avoid 
 eating the shoes and fish bones! Player’s physical movements 
 control the motion of an animated mouth within the game, 
 which must be carefully maneuvered to eat the food.  
 Chomp uses Kyle Macdonald’s FaceOSC app to track the 
 coordinates of the players mouth within the screen, and 
 this data is sent to Processing and used to animate the 
 cartoon mouth. Eating a donut or taco adds a point to the 
 players score, but you can quickly lose points by eating shoes
 and fish bones. To win this two-player game, players must 
 quickly eat enough to reach eight points before their opponent. 
 */

/*
 faceOSC app available for download here:
 https://github.com/kylemcdonald/ofxFaceTracker/downloads
 */

// template for receiving faceOSC messages from  Alan on http://golancourses.net/2013/category/project-1/face-osc/
//Doughnut by Julia Soderberg from The Noun Project
// Dead Fish by Jalele from The Noun Project
//Shoe by Guvnor Co from The Noun Project
//Taco by Victoria Benavides from The Noun Project


//import libraries
import processing.net.*;
import oscP5.*;
OscP5 oscP5;

PFont font;


Client client;
String input;
int data[];

// import data from faceOSC
PVector posePosition;
boolean found;
float mouthHeight;
float mouthWidth;
float poseScale;

//import images
PImage upperTeeth;
PImage lowerTeeth;
PImage taco;
PImage shoe;
PImage donut;
PImage fish;

// variables for shoe position
float xPos;
float yPos;
float xSpeed = 2.2;
float ySpeed = 1.5;

//variables for taco position
float xaPos = random (500);
float yaPos = random (500);
float xaSpeed = 3;
float yaSpeed = 2.0;

// variables for doughnut position
float xdPos = random (500);
float ydPos = random (500);
float xdSpeed = 2.0;
float ydSpeed = 1.8;

//variables for fish position
float xfPos = random (500);
float yfPos = random (500);
float xfSpeed = 2.5;
float yfSpeed = 2.0;

// reset the location of food once it's been eaten 
float xReset;
float yReset;
float xaReset;
float yaReset;
float xdReset;
float ydReset;
float xfReset;
float yfReset;

// start score at 0
int score = 0;


void setup() {
  size(640, 480);
  frameRate(30);
  smooth(); 

  font = loadFont("Consolas-Italic-48.vlw");
  textFont(font);
//127.0.0.1

  client = new Client(this, "192.168.0.12", 12345); // replace with servers IP

  // faceOSC data
  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseScale", "/pose/scale");

  // load images saved in data folder
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  noStroke();
  fill(0);
  textSize(20);

  upperTeeth= loadImage("upperTeeth.png");
  lowerTeeth= loadImage("lowerTeeth.png");
  taco = loadImage("taco.png");
  shoe = loadImage("shoe.png");
  donut = loadImage("donut.png");
  fish = loadImage("fish.png");
}


void draw() {  

  background(255);

  food();
  clientData();
  winScreen();
}


void clientData() {
  // client.write(score + "\n");

  // read incoming data
  if (client.available() > 0) {
    client.write(score + "\n");
    input = client.readString();
    input = input.substring(0, input.indexOf("\n")); //only up to the new line
    data = int(split(input, ' ')); //split values into an array

    //write opponents score
    text(data[0], 130, 80);


    // if oponents score is equal or greater than 8, display a LOSE screen
    // and stop the movement of all food / non-food
    if (data[0]>=8) {
      fill(#FF2E17);
      rect(width/2, height/2, width, height);
      fill(255);
      text("You Lose", width/2, height/2);
      xSpeed = 0;
      ySpeed = 0;
      xaSpeed = 0;
      yaSpeed = 0;
      ydSpeed = 0;
      xdSpeed = 0;
      yfSpeed = 0;
      xfSpeed = 0;
    } // close if
  } // close available client
}//close client data

void winScreen() {
  // if players score is 8, display a WIN screen
  // and stop the movement of all food/ non-food
  if (score>=8) {
    fill(#7CED41);
    rect(width/2, height/2, width, height);
    fill(255);
    text("You Win", width/2, height/2);
    xSpeed = 0;
    ySpeed = 0;
    xaSpeed = 0;
    yaSpeed = 0;
    yfSpeed = 0;
    xfSpeed = 0;
    ydSpeed = 0;
    xdSpeed = 0;
  }
}

void food() {
  // once the food is eaten, move it to a random position on the screen
  xReset = random(500);
  yReset = random(500);
  xaReset = random(500);
  yaReset = random(500);
  xdReset = random(500);
  ydReset = random(500);
  xfReset = random(500);
  yfReset = random(500);

  // place score headline text
  text("Your Score", width-130, 40);
  text("Opponent's Score", 130, 40);

  text(score, width-130, 80);

  //CONTROLS shoe LOCATION
  xPos = xPos + xSpeed;
  yPos = yPos + ySpeed;

  // make sure the shoe stays on the page
  if ((xPos > width) || (xPos < 0)) {
    xSpeed = xSpeed * -1;
  }
  if ((yPos > height) || (yPos < 0)) {
    ySpeed = ySpeed * -1;
  }

  //controls taco location
  xaPos = xaPos + xaSpeed;
  yaPos = yaPos + yaSpeed;

  // make sure taco stays on the page
  if ((xaPos > width) || (xaPos < 0)) {
    xaSpeed = xaSpeed * -1;
  }
  if ((yaPos > height) || (yaPos < 0)) {
    yaSpeed = yaSpeed * -1;
  }

  //move doughnut and make sure makesure doughnut stays on the screen
  xdPos = xdPos + xdSpeed;
  ydPos = ydPos + ydSpeed;
  if ((xdPos > width) || (xdPos < 0)) {
    xdSpeed = xdSpeed * -1;
  }
  if ((ydPos > height) || (ydPos < 0)) {
    ydSpeed = ydSpeed * -1;
  }

  //move fish and makesure fish stays on the screen
  xfPos = xfPos + xfSpeed;
  yfPos = yfPos + yfSpeed;

  if ((xfPos > width) || (xfPos < 0)) {
    xfSpeed = xfSpeed * -1;
  }

  if ((yfPos > height) || (yfPos < 0)) {
    yfSpeed = yfSpeed * -1;
  }

  // place images
  image(shoe, xPos, yPos, 80, 80);
  image(taco, xaPos, yaPos, 80, 80);
  image(donut, xdPos, ydPos, 60, 60);
  image(fish, xfPos, yfPos, 70, 70);

  if (found) {
    // if the coordinates of the shoe are within the mouth vector, add a point and move the shoe to a random location
    if ((xPos<=(0-posePosition.x)+width + mouthWidth*4) && (xPos>=(0-posePosition.x)+width-mouthWidth*5) && (yPos<=posePosition.y+mouthHeight*4) && (yPos>=posePosition.y-mouthHeight*4)) {
      xPos= xReset ;
      yPos = yReset;
      score+= -1;
    }

    // if the coordinates of the taco are within the mouth vector, add a point and move the taco to a random location
    if ((xaPos<=(0-posePosition.x)+width+mouthWidth*4) && (xaPos>=(0-posePosition.x)+width - mouthWidth*5) && (yaPos<=posePosition.y+mouthHeight*4) && (yaPos>=posePosition.y-mouthHeight*4)) {
      xaPos= xaReset ;
      yaPos = yaReset;
      score+= 1;
    }

    // if the coordinates of the donut are within the mouth vector, add a point a point and move the donut to a random location
    if ((xdPos<=(0-posePosition.x)+width+mouthWidth*4) && (xdPos>=(0-posePosition.x)+width - mouthWidth*5) && (ydPos<=posePosition.y+mouthHeight*4) && (ydPos>=posePosition.y-mouthHeight*4)) {
      xdPos= xdReset ;
      ydPos = ydReset;
      score+= 1;
    }

    // if the coordinates of the fish are within the mouth vector, subtract a point and move the fish to a random location
    if ((xfPos<=(0-posePosition.x)+width+mouthWidth*4) && (xfPos>=(0-posePosition.x)+width - mouthWidth*5) && (yfPos<=posePosition.y+mouthHeight*4) && (yfPos>=posePosition.y-mouthHeight*4)) {
      xfPos= xdReset ;
      yfPos = ydReset;
      score+= -1;
    }   

    // import images of teeth, controled by location of mouth on FaceOSC app
    image(upperTeeth, (0-posePosition.x)+width, posePosition.y-mouthHeight*4, mouthWidth*10, mouthHeight+50);
    image(lowerTeeth, (0-posePosition.x)+width, posePosition.y+mouthHeight*4, mouthWidth*10, mouthHeight+50);
  }
}

public void mouthWidthReceived(float w) {
  //println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  //mouthHeight = h;
}

public void found(int i) {
  //println("found: " + i); // 1 == found, 0 == not found
  found = i == 1;
}

public void posePosition(float x, float y) {
 // println("pose position\tX: " + x + " Y: " + y );
  posePosition = new PVector(x, y);
}

public void poseScale(float s) {
  ////println("scale: " + s);
  poseScale = s;
}

public void poseOrientation(float x, float y, float z) {
  //println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged()==false) {
    //println("UNPLUGGED: " + theOscMessage);
  }
}

