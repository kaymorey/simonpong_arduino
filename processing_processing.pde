import processing.serial.*;

Serial myPort;
String stringReceived;
String[] moves;
int playerLeft;
int playerRight;
int bgSize = 800;
int radius = 20;
int semiRadius = radius/2;
int xCircle = (bgSize-radius)/2;
int yCircle = (bgSize-radius)/2;
int barLeft = (bgSize-100)/2;
int barRight = (bgSize-100)/2;
int xBallSpeed = 5;
float yBallSpeed = random(-xBallSpeed, xBallSpeed);
boolean goRight = true;
boolean goTop;
boolean hasWaited =false;
boolean isLost = false;


void setup() {
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);
  
  size(bgSize,bgSize);
  background(0, 0, 0);
  
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
  
  ballMove();
  fill(255,255,255);
  rect(0,barLeft,20,100);
  rect(bgSize-20,barRight,20,100);
  
  
  //if(val>=0){
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
    
    barLeft = playerLeft*(bgSize-100)/255;
    barRight = playerRight*(bgSize-100)/255;
    //controllerPos = val*(bgSize-100)/255;
    
  //}
}

void ballMove() {
  background(0, 0, 0);
  if(isLost){
    isLost = false;
    xBallSpeed = 5;
    yCircle=(bgSize-radius)/2;
    xCircle=(bgSize-radius)/2;
  }
  if(goRight && xCircle > (bgSize-(20+semiRadius)) && yCircle > barRight && yCircle < barRight+100){
      goRight = false;
      xBallSpeed++;
      
  }
  else if(!goRight && xCircle < 20+semiRadius && yCircle > barLeft && yCircle < barLeft+100) {
      goRight = true;
      xBallSpeed++;
  }
  
  if(xCircle < 0 || xCircle > bgSize){
   isLost = true; 
  }
    
  if(goRight) {
    xCircle += xBallSpeed; 
  }
  else {
    xCircle -= xBallSpeed;
  }
    
    
  if(goTop && yCircle < semiRadius) {
    goTop = false;
  }
  else if(!goTop && yCircle > bgSize-semiRadius){
    goTop = true; 
  }
  
  if(goTop) {
    yCircle -= yBallSpeed; 
  }
  else {
    yCircle += yBallSpeed; 
  }
    
  ellipse(xCircle, yCircle, radius, radius);
}

