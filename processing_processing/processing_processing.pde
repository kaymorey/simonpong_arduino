import processing.serial.*;

Serial myPort;
String stringReceived;
String[] moves;
int playerLeft;
int playerRight;
int screenWidth  = 800;
int screenHeight = 600;

// Ball
int radiusBall = 20;
int posXBall = (screenWidth - radiusBall)/2;
int posYBall = (screenHeight - radiusBall)/2;
int incrementXBall = 3;
int incrementYBall = 2;

// Bar
int barWidth = 100;
int barHeight = 20;
// Bar Top
int posXBarTop = (screenWidth - barWidth)/2;
int posYBarTop = 0;
// Bar Bottom
int posXBarBottom = (screenWidth - barWidth)/2;
int posYBarBottom = screenHeight - barHeight;

boolean hasWaited =false;

 // Changing dimensions
 boolean isExpanding = false;
 String barExpanding = "";

Ball ball;

Bar barTop;
Bar barBottom;

void setup() {
  /*String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);*/
  
  size(screenWidth, screenHeight);
  background(0, 0, 0);
  
  ball = new Ball(radiusBall, posXBall, posYBall, incrementXBall, incrementYBall);
  barTop = new Bar(barWidth, barHeight, posXBarTop, posYBarTop);
  barBottom = new Bar(barWidth, barHeight, posXBarBottom, posYBarBottom);
}

void draw()
{
  if(!hasWaited){
     hasWaited = true;
    delay(1000); 
  }
  
  background(0, 0, 0);
  
  barTop.drawBar();
  barBottom.drawBar();
  
  ball.moveBall();
  
  if (ball.testBallHitBar(barTop.posXBar, barTop.posYBar)) {
    ball.changeBallDirection(barTop.posXBar, 1);
  }
  else if (ball.testBallHitBar(barBottom.posXBar, barBottom.posYBar)) {
    ball.changeBallDirection(barBottom.posXBar, -1);
  }
  
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT && barTop.posXBar > 0) {
        barTop.posXBar -= 5;
      }
      else if (keyCode == RIGHT && barTop.posXBar < screenWidth - barWidth) {
        barTop.posXBar += 5;
      } 
    }
    else {
      if ((key == 'q' || key == 'Q') && barBottom.posXBar > 0) {
        barBottom.posXBar -= 5;
      }
      else if ((key == 's' || key == 'S') && barBottom.posXBar < screenWidth - barWidth) {
        barBottom.posXBar += 5;
      }
      else if (key == 'e' || key == 'E') {
        // Expand top bar
        barTop.expandBar("top");
      }
    }
  }
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

