import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class processing_processing extends PApplet {



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

Ball ball;

Bar barTop;
Bar barBottom;

Score score;

public void setup() {
    /*String portName = Serial.list()[5];
    myPort = new Serial(this, portName, 9600);*/

    size(screenWidth, screenHeight);
    background(41, 41, 41);

    ball = new Ball(radiusBall, posXBall, posYBall, incrementXBall, incrementYBall);
    barTop = new Bar(barWidth, barHeight, posXBarTop, posYBarTop);
    barBottom = new Bar(barWidth, barHeight, posXBarBottom, posYBarBottom);

    score = new Score();
}

public void draw()
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

    // Score
    if (ball.posYBall > screenHeight) {
        score.topScore += 1;
        ball.initBall();
    }
    else if (ball.posYBall < 0) {
        score.bottomScore += 1;
        ball.initBall();
    }

    // Ball
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

public void drawLine()
{
    stroke(255);
    line(0, screenHeight / 2, screenWidth, screenHeight / 2);
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


class Ball
{
    int radiusBall;
    int posXBall;
    int posYBall;
    int incrementXBall;
    int incrementYBall;

    Ball(int radius, int posX, int posY, int incrementX, int incrementY) {
        radiusBall = radius;
        posXBall = posX;
        posYBall = posY;
        incrementXBall = incrementX;
        incrementYBall = incrementY;
    }

    public void initBall()
    {
        posXBall = (screenWidth - radiusBall)/2;
        posYBall = (screenHeight - radiusBall)/2;
        incrementXBall = 3;
        incrementYBall = 2;
    }

    public void drawBall()
    {
        fill(255,255,255);
        ellipse(posXBall, posYBall, radiusBall, radiusBall);
    }

    public void moveBall()
    {
        posXBall += incrementXBall;
        if (posXBall + radiusBall / 2 > screenWidth || posXBall - radiusBall / 2 < 0) {
            incrementXBall = -incrementXBall;
        }
        posYBall += incrementYBall;
        drawBall();
    }

    public boolean testBallHitBar(int posXBar, int posYBar) {
        if ((posXBall + radiusBall / 2 >= posXBar && posXBall - radiusBall / 2 <= posXBar + barWidth) && (posYBall + radiusBall / 2 >= posYBar && posYBall - radiusBall / 2 <= posYBar + barHeight)) {
            // Collision
            return true;
        }
        return false;
    }

    public boolean testBallHitTop(int posXBar, int posYBar) {
        if (posYBall < 0 && !testBallHitBar(posXBar, posXBar)) {
            return true;
        }
        return false;
    }

    public boolean testBallHitBottom(int posXBar, int posYBar) {
        if (posYBall > screenHeight && !testBallHitBar(posXBar, posYBar)) {
            return true;
        }
        return false;
    }

    public void changeBallDirection(int posXBar, int multi) {
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

    public int posBallHitBar (int posXBar) {
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
}
class Bar
{
    int initialWidth;
    int barWidth;
    int barHeight;
    int posXBar;
    int posYBar;

    int maxWidth = 300;
    int minWidth = 60;

    Bar (int bWidth, int bHeight, int posX, int posY)
    {
        initialWidth = bWidth;
        barWidth = bWidth;
        barHeight = bHeight;
        posXBar = posX;
        posYBar = posY;
    }

    public void drawBar()
    {
        fill(255,255,255);
        rect(posXBar, posYBar, barWidth, barHeight);
    }

    public void expandBar()
    {
        if (barWidth + 20 <= maxWidth) {
            barWidth += 20;
            posXBar -= 10;
        }
    }

    public void shrinkBar()
    {
        if (barWidth - 20 >= minWidth) {
            barWidth -= 20;
            posXBar += 10;
        }
    }
}

class Score {
    int topScore;
    int bottomScore;

    Score()
    {
        topScore = 0;
        bottomScore = 0;
    }

    public void displayTopScore()
    {
        String s = str(topScore);
        fill(28, 28, 28);
        textFont(loadFont("BebasNeue-100.vlw"));
        text(s, (screenWidth - textWidth(s)) / 2, screenHeight / 4 + 50); // 50 is font-size / 2
    }

    public void displayBottomScore()
    {
        String s = str(bottomScore);
        fill(28, 28, 28);
        textFont(loadFont("BebasNeue-100.vlw"));
        text(s, (screenWidth - textWidth(s)) / 2, screenHeight - (screenHeight / 4 - 50)); // 50 is font-size / 2
    }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "processing_processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
