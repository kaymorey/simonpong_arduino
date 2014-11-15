import processing.serial.*;

Serial myPort;
String stringReceived;
String[] moves;
int playerLeft;
int playerRight;
int bgSize = 600;

// Bars
  // Dimensions
int barWidth = 100;
int barHeight = 20;
  
  // Positions
int posXBarTop;
int posYBarTop;
int posXBarBottom;
int posYBarBottom;

// Ball
  // Dimension
int radiusBall = 20;

  // Positions
int posXBall;
int posYBall;
  // Speed
int incrementXBall;
int incrementYBall;

int xBallSpeed = 5;
float yBallSpeed = random(-xBallSpeed, xBallSpeed);
boolean goRight = true;
boolean goTop;
boolean hasWaited =false;
boolean isLost = false;


void setup() {
  /*String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);*/
  
  size(bgSize, bgSize);
  background(0, 0, 0);
  
  // Set bars positions
  posXBarTop = (bgSize - barWidth)/2;
  posYBarTop = 0;
  posXBarBottom = (bgSize - barWidth)/2;
  posYBarBottom = bgSize - barHeight;
  
  // Set ball position
 posXBall = (bgSize - radiusBall)/2;
 posYBall = (bgSize - radiusBall)/2;
 
  // Set ball increments
incrementXBall = 3;
incrementYBall = 2;
  
  if(yBallSpeed < 0) {
    goTop = true;
  }
  else {
    goTop = false;
  }
  
  
}

void draw()
{
  if(!hasWaited){
     hasWaited = true;
    delay(1000); 
  }
  
  background(0, 0, 0);
  
  ballMove();
  
  // Draw bars
  drawBars();
  // Draw and move Ball
  moveBall();
  
  if (testBallHitBar(posXBarTop, posYBarTop)) {
    changeBallDirection(posXBarTop, 1);
  }
  else if (testBallHitBar(posXBarBottom, posYBarBottom)) {
    changeBallDirection(posXBarBottom, -1);
  }
  
  
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT && posXBarTop > 0) {
        posXBarTop -= 5;
      }
      else if (keyCode == RIGHT && posXBarTop < bgSize - barWidth) {
        posXBarTop += 5;
      } 
    }
    else {
      if ((key == 'q' || key == 'Q') && posXBarBottom > 0) {
        posXBarBottom -= 5;
      }
      else if ((key == 's' || key == 'S') && posXBarBottom < bgSize - barWidth) {
        posXBarBottom += 5;
      }
    }
  }
}

void drawBars()
{
  fill(255,255,255);
  rect(posXBarTop, posYBarTop, barWidth, barHeight);
  rect(posXBarBottom, posYBarBottom, barWidth, barHeight);
}

void drawBall()
{
  fill(255,255,255);
  ellipse(posXBall, posYBall, radiusBall, radiusBall);
}

void moveBall()
{
  posXBall += incrementXBall;
  if (posXBall > bgSize || posXBall < 0) {
    incrementXBall = -incrementXBall;
  }
  posYBall += incrementYBall;
  if (posYBall > bgSize || posYBall < 0) {
    incrementYBall = -incrementYBall;
  }
  drawBall();
}

boolean testBallHitBar(int posXBar, int posYBar) {
  if ((posXBall + radiusBall / 2 >= posXBar && posXBall - radiusBall / 2 <= posXBar + barWidth) && (posYBall + radiusBall / 2 >= posYBar && posYBall - radiusBall / 2 <= posYBar + barHeight)) {
    // Collision
    return true;
  }
  return false;
}

void changeBallDirection(int posXBar, int multi) {
  // If collision with top bar multi equals 1 else multi equals -1 (ball going to top or bottom)
  switch (posBallHitBar(posXBar)) {
    case -2:
      incrementXBall = -3;
      incrementYBall = 2 * multi; 
       break;
    case -1:
      incrementXBall = -2;
      incrementYBall = 2 * multi;
      break;
    case 0:
      incrementXBall = 0;
      incrementYBall = 3 * multi;
      break;
    case 1:
      incrementXBall = 2;
      incrementYBall = 2 * multi;
      break;
    case 2:
      incrementXBall = 3;
      incrementYBall = 2 * multi;
      break;
  }
}

int posBallHitBar (int posXBar) {
  int rangeBar = barWidth / 5;
  if (posXBall > posXBar && posXBall < posXBar + rangeBar) {
    return -2; // LEFT
  }
  else if (posXBall >= posXBar + rangeBar && posXBall < posXBar + rangeBar * 2) {
    return -1; // MIDLEFT
  }
  else if (posXBall >= posXBar + barWidth - rangeBar * 2 && posXBall < posXBar + barWidth - rangeBar) {
    return 1; // MIDRIGHT
  }
  else if (posXBall < posXBar + barWidth && posXBall >= posXBar + barWidth - rangeBar) {
    return 2; // RIGHT
  }
  return 0; // MIDDLE
}

void ballMove() {
//  background(0, 0, 0);
//  if(isLost){
//    isLost = false;
//    xBallSpeed = 5;
//    yCircle=(bgSize-radius)/2;
//    xCircle=(bgSize-radius)/2;
//  }
//  if(goRight && xCircle > (bgSize-(20+semiRadius)) && yCircle > posYBarRight && yCircle < posYBarRight+100){
//      goRight = false;
//      xBallSpeed++;
//      
//  }
//  else if(!goRight && xCircle < 20+semiRadius && yCircle > posYBarLeft && yCircle < posYBarLeft+100) {
//      goRight = true;
//      xBallSpeed++;
//  }
//  
//  if(xCircle < 0 || xCircle > bgSize){
//   isLost = true; 
//  }
//    
//  if(goRight) {
//    xCircle += xBallSpeed; 
//  }
//  else {
//    xCircle -= xBallSpeed;
//  }
//    
//    
//  if(goTop && yCircle < semiRadius) {
//    goTop = false;
//  }
//  else if(!goTop && yCircle > bgSize-semiRadius){
//    goTop = true; 
//  }
//  
//  if(goTop) {
//    yCircle -= yBallSpeed; 
//  }
//  else {
//    yCircle += yBallSpeed; 
//  }
//    
//  ellipse(xCircle, yCircle, radius, radius);
}

// Get arduino data and change bars pos in draw function
/*if(val>=0){
    if(myPort.available() > 0){
      stringReceived = myPort.readStringUntil('\n');
      if(stringReceived != null) {
        
        moves = split(stringReceived,'$');
        
        if(moves.length == 2){
          
          playerLeft = int(moves[0].trim());
          playerRight = int(moves[1].trim());
        }
      }
    }
    
    posYBarLeft = playerLeft*(bgSize-100)/255;
    posYBarRight = playerRight*(bgSize-100)/255;
    //controllerPos = val*(bgSize-100)/255;
    
  }*/

