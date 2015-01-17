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

Score score;

void setup() {
    /*String portName = Serial.list()[5];
    myPort = new Serial(this, portName, 9600);*/

    size(screenWidth, screenHeight);
    background(41, 41, 41);

    ball = new Ball(radiusBall, posXBall, posYBall, incrementXBall, incrementYBall);
    barTop = new Bar(barWidth, barHeight, posXBarTop, posYBarTop);
    barBottom = new Bar(barWidth, barHeight, posXBarBottom, posYBarBottom);

    score = new Score();
}

void draw()
{
    if(!hasWaited){
        hasWaited = true;
        delay(1000);
    }

    background(41, 41, 41);

    drawLine();

    score.displayTopScore();
    score.displayBottomScore();

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
                barTop.expandBar();
            }
            else if (key == 'r' || key == 'R') {
                barTop.shrinkBar();
            }
        }
    }
}

void drawLine()
{
    stroke(255);
    line(0, screenHeight / 2, screenWidth, screenHeight / 2);
}

void displayText()
{
    String s = "4";
    fill(28, 28, 28);
    textFont(loadFont("BebasNeue-100.vlw"));
    text(s, (screenWidth - textWidth(s)) / 2, screenHeight / 4 + 50); // 50 is font-size / 2
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

