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

public class SimonPong_Processing extends PApplet {


int conteur = 0;

Serial myPort;
String stringReceived;
String[] moves;
int playerTopLeft;
int playerTopRight;
int screenWidth  = 800;
int screenHeight = 600;

// Pong
Pong pongLeft;

// Players
int nbPlayers = 4;
Player[] players = new Player[nbPlayers];

// Bars
Bar[] bars = new Bar[nbPlayers];
int barWidth = 100;
int barHeight = 20;
int barSpeed = 5;
boolean increase = true;

// Ball
Ball ball;

int radiusBall = 20;
int posXBall = screenWidth / 2;
int posYBall = screenHeight / 2;

// Bar Top
int posXBarTop = (screenWidth - barWidth)/2;
int posYBarTop = 0;
// Bar Bottom
int posXBarBottom = (screenWidth - barWidth)/2;
int posYBarBottom = screenHeight - barHeight;

// Score
Score scorePlayerTop;
Score scorePlayerBottom;

int scorePlayer = 0;
// Score Top
int scorePosYTop = screenHeight / 4 + 50;
// Score Bottom
int scorePosYBottom = screenHeight - (screenHeight / 4 - 50);

// Simon
Simon simon;
int numberOfLed = 4;
int numberOfColorInSequence = 3;

// SimonResolver
SimonResolver simonResolver;
boolean hasWaitedToReadInput = false;
int returnedValueByResolver = 0; // /!\ cette variable doit \u00eatre celle du jour et r\u00e9cup\u00e9r\u00e9e pour chaque joueur. N'appara\u00eet pas dans le main.


boolean hasWaited = false;

public void setup() {
    
    instantiateArduino();

    size(screenWidth, screenHeight);
    background(41, 41, 41);

    for (int i = 0; i < nbPlayers; i++) {
        bars[i] = new Bar(barWidth, barHeight, i);
        players[i] = new Player(i + 1, bars[i]);
    }

    ball = new Ball(radiusBall, posXBall, posYBall);
    scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);

    pongLeft = new Pong(800, 600, 0, 0, color(41, 41, 41), players, ball);

    simon = new Simon(numberOfColorInSequence, numberOfLed);
    simonResolver = new SimonResolver(simon.sequenceToPlay);

    simon.play();
}

public void draw()
{
    pongLeft.draw();
  
/*
    scorePlayerTop.displayScore();
    scorePlayerBottom.displayScore();
*/

    readArduino();
    //readKeyboard();
}

public void instantiateArduino()
{
    String portName = Serial.list()[3];
    myPort = new Serial(this, portName, 9600);
}

public void readArduino()
{
    if(!hasWaited){
        hasWaited = true;
        delay(1000);
    }

    if(myPort.available() > 0){
        stringReceived = myPort.readStringUntil('\n');
        if(stringReceived != null) {

            moves = split(stringReceived,'$');

            if(moves.length == 3){
                switch (PApplet.parseInt(moves[2].trim())) {
                    case 0 :
                        returnedValueByResolver = simonResolver.compareSolution(0);
                        break;
                    case 1 :
                        returnedValueByResolver = simonResolver.compareSolution(1);
                        break;
                    case 2 :
                        returnedValueByResolver = simonResolver.compareSolution(2);
                        break;
                    case 3 :
                        returnedValueByResolver = simonResolver.compareSolution(3);
                        break;
                }

                if(returnedValueByResolver == 2) {
                    resetSimon();
                }

                playerTopLeft = PApplet.parseInt(moves[1].trim());
                playerTopRight = PApplet.parseInt(moves[0].trim());
                /* from 0q to 255 */
                // println("playerLeft: "+playerLeft);
                // println("playerRight: "+playerRight);
                bars[0].posX = playerTopLeft*(screenWidth/2-bars[0].width)/255;
                bars[1].posX = playerTopRight*(screenWidth/2-bars[1].width)/255 + screenWidth/2;
            }
        }
    }
}

public void resetSimon()
{
    returnedValueByResolver = 0;
    simon.win();
    simon = new Simon(++numberOfColorInSequence,numberOfLed);
    simonResolver = new SimonResolver(simon.sequenceToPlay);
    simon.play();
}

public void readKeyboard()
{
    if (keyPressed) {
        // if (key == CODED) {
        //     if (keyCode == LEFT) {
        //          if (!barTop.controlInverted && barTop.posXBar > 0) {
        //              barTop.posXBar -= 5;
        //          }
        //          else if (barTop.controlInverted && barTop.posXBar < screenWidth - barTop.barWidth) {
        //              barTop.posXBar += 5;
        //          }
        //      }
        //      else if (keyCode == RIGHT) {
        //          if (!barTop.controlInverted && barTop.posXBar < screenWidth - barTop.barWidth) {
        //              barTop.posXBar += 5;
        //          }
        //          else if (barTop.controlInverted && barTop.posXBar > 0) {
        //              barTop.posXBar -= 5;
        //          }
        //      }
        // }
        // else {
        //     if (key == 'q' || key == 'Q') {
        //          if (!barBottom.controlInverted && barBottom.posXBar > 0) {
        //              barBottom.posXBar -= 5;
        //          }
        //          else if (barBottom.controlInverted && barBottom.posXBar < screenWidth - barBottom.barWidth) {
        //              barBottom.posXBar += 5;
        //          }
        //      }
        //      else if ((key == 's' || key == 'S')) {
        //          if (!barBottom.controlInverted && barBottom.posXBar < screenWidth - barBottom.barWidth) {
        //              barBottom.posXBar += 5;
        //          }
        //          else if (barBottom.controlInverted && barBottom.posXBar > 0) {
        //              barBottom.posXBar -= 5;
        //          }
        //      }
        //     else if (key == 'e' || key == 'E') {
        //         barTop.expandBar();
        //     }
        //     else if (key == 'r' || key == 'R') {
        //         barTop.shrinkBar();
        //     }
        //     else if (key == 'a' || key == 'A') {
        //         barTop.speedBar(increase);
        //     }
        //     else if (key == 'z' || key == 'Z') {
        //         barTop.speedBar(!increase);
        //     }
        //     else if (key == 'w' || key == 'W') {
        //         barTop.controlInverted = !barTop.controlInverted;
        //     }
        //     else if (key == 'x' || key == 'X') {
        //         barBottom.controlInverted = !barBottom.controlInverted;
        //     }
        //       else if (key == '0' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(0));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        //      else if (key == '1' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(1));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        //      else if (key == '2' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(2));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        //      else if (key == '3' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(3));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        // }
    }
}




class Ball
{
    int radius;
    int posX;
    int posY;
    int incrementX;
    int incrementY;
    int[] incrementsY = {3, -3};

    Ball(int radiusBall, int posXBall, int posYBall) {
        radius = radiusBall;
        posX = posXBall;
        posY = posYBall;
        initIncrements();
    }

    public void initBall()
    {
        posX = (screenWidth - radius)/2;
        posY = (screenHeight - radius)/2;
        initIncrements();
    }

    public void initIncrements()
    {
        incrementX = PApplet.parseInt(random(-4, 4));

        int index = PApplet.parseInt(random(2));
        incrementY = incrementsY[index];
    }

    public void drawBall()
    {
        fill(255,255,255);
        ellipse(posX, posY, radius, radius);
    }

    public void moveBall()
    {
        posX += incrementX;
        if (posX + radius / 2 > screenWidth || posX - radius / 2 < 0) {
            incrementX = -incrementX;
        }
        posY += incrementY;
        drawBall();
    }

    public boolean testBallHitBar(Bar bar) {

        if ((posX + radius / 2 >= bar.posX && posX - radius / 2 <= bar.posX + bar.width) && (posY + radius / 2 >= bar.posY && posY - radius / 2 <= bar.posY + bar.height)) {
            // Collision
            return true;
        }
        return false;
    }

    public void changeBallDirection(int posXBar, int multi) {
        // If collision with top bar multi equals 1 else multi equals -1 (ball going to top or bottom)
        switch (posBallHitBar(posXBar)) {
            case -2:
                incrementX = -3;
                incrementY = 2 * multi;
                break;
            case -1:
                incrementX = -2;
                incrementY = 2 * multi;
                break;
            case 0:
                incrementX = 0;
                incrementY = 3 * multi;
                break;
            case 1:
                incrementX = 2;
                incrementY = 2 * multi;
                break;
            case 2:
                incrementX = 3;
                incrementY = 2 * multi;
                break;
        }
    }

    public int posBallHitBar (int posXBar) {
        int rangeBar = barWidth / 5;
        if (posX > posXBar && posX < posXBar + rangeBar) {
            return -2; // LEFT
        }
        else if (posX >= posXBar + rangeBar && posX < posXBar + rangeBar * 2) {
            return -1; // MIDLEFT
        }
        else if (posX >= posXBar + barWidth - rangeBar * 2 && posX < posXBar + barWidth - rangeBar) {
            return 1; // MIDRIGHT
        }
        else if (posX < posXBar + barWidth && posX >= posXBar + barWidth - rangeBar) {
            return 2; // RIGHT
        }
        return 0; // MIDDLE
    }
}
class Bar
{
    int posX;
    int posY;
    int barSpeed;

    int initialWidth;
    int width;
    int height;
    int maxWidth = 300;
    int minWidth = 60;
    
    int maxSpeed = 20;
    int minSpeed = 1;
    boolean controlInverted = false;

    // Bar (int bWidth, int bHeight, int posX, int posY, int speed)
    // {
    //     initialWidth = bWidth;
    //     barWidth = bWidth;
    //     barHeight = bHeight;
    //     posXBar = posX;
    //     posYBar = posY;
    //     barSpeed = speed;
    // }

    Bar (int barWidth, int barHeight, int index)
    {
        initialWidth = width;
        width = barWidth;
        height = barHeight;

        switch (index) {
            case 0:
                posX = screenWidth / 4 - barWidth / 2;
                posY = 0;
                break;
            case 1:
                posX = 3 * screenWidth / 4 - barWidth / 2;
                posY = 0;
                break;
            case 2:
                posX = screenWidth / 4 - barWidth / 2;
                posY = screenHeight - height;
                break;
            case 3:
                posX = 3 * screenWidth / 4 - barWidth / 2;
                posY = screenHeight - height;
                break;

        }
    }

    public void draw()
    {
        fill(255,255,255);
        rect(posX, posY, width, height);
        //triangle(posXBar+barWidth, barHeight, posXBar+barWidth, posYBar, posXBar+barWidth+50, posYBar);
    }

    public void expandBar()
    {
        if (width + 20 <= maxWidth) {
            width += 20;
            posX -= 10;
        }
    }

    public void shrinkBar()
    {
        if (width - 20 >= minWidth) {
            width -= 20;
            posX += 10;
        }
    }
    
    public void speedBar(boolean increase)
    {
        if (increase && (barSpeed + 5 <= maxSpeed)) {
            barSpeed += 5;
        }
        else if (!increase && (barSpeed - 5 >= minSpeed)) {
          barSpeed -= 5;
        }
    }
}

class Color
{
    int identifier;

    Color(int valueToIdentify) {
        identifier = valueToIdentify;
    }
}
class Player
{
	int index;
	Bar bar;

	Player(int indexPlayer, Bar playerBar)
	{
		index = indexPlayer;
		bar = playerBar;
	}

    public void draw()
    {
        bar.draw();
    }
}

class Pong
{
    int width;
    int height;
    int posX;
    int posY;
    int backgroundColor;
    Player[] players;
    Ball balls;
    
     
    Pong(int pongWidth, int pongHeight, int pongPosX, int pongPosY, int pongBackground, Player[] pongPlayers, Ball pongBalls) {
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        balls = pongBalls;
    }
    
    public void draw()
    {
        size(width, height);
        background(41, 41, 41);

        drawLine();

        for (int i = 0; i < nbPlayers; i++) {
            players[i].draw();
        }
        /*
        scorePlayerTop.displayScore();
        scorePlayerBottom.displayScore();
        
        barTop.drawBar();
        barBottom.drawBar();
        */

        // Score
        if (ball.posY > height) {
            scorePlayerTop.scorePlayer += 1;
            ball.initBall();
        }
        else if (ball.posY < 0) {
            scorePlayerBottom.scorePlayer += 1;
            ball.initBall();
        }
        
        // Ball
        ball.moveBall();

        if (ball.testBallHitBar(players[0].bar)) {
            ball.changeBallDirection(players[0].bar.posX, 1);
        }
        else if (ball.testBallHitBar(players[1].bar)) {
            ball.changeBallDirection(players[1].bar.posX, -1);
        }
    }
    
    public void drawLine()
    {
        stroke(28, 28, 28);
        line(0, height / 2, width, height / 2);
    }
}
class Score {
    PFont scoreFont = loadFont("BebasNeue-100.vlw");
    String scoreText;
    int scorePlayer;
    int scorePosY;

    Score(int score, int posY)
    {
        scoreText = str(score);
        scorePlayer = score;
        scorePosY = posY;
    }

     public void displayScore()
    {
        scoreText = str(scorePlayer);
        fill(28, 28, 28);
        textFont(scoreFont);
        text(scoreText, (screenWidth - textWidth(scoreText)) / 2, scorePosY); // 50 is font-size / 2
    }
/*
    void displayTopScore()
    {
        String s = str(topScore);
        fill(28, 28, 28);
        textFont(loadFont("BebasNeue-100.vlw"));
        text(s, (screenWidth - textWidth(s)) / 2, screenHeight / 4 + 50); // 50 is font-size / 2
    }

    void displayBottomScore()
    {
        String s = str(bottomScore);
        fill(28, 28, 28);
        textFont(loadFont("BebasNeue-100.vlw"));
        text(s, (screenWidth - textWidth(s)) / 2, screenHeight - (screenHeight / 4 - 50)); // 50 is font-size / 2
    }
*/
}

class Simon
{
    ArrayList<Color> availableColors = new ArrayList<Color>();
    ArrayList<Integer> sequenceToPlay = new ArrayList<Integer>();

    Simon(int numberOfItems, int numberOfLeds) {
        for (int i = 0; i < numberOfLeds; i++) {
            Color colorToAdd = new Color(i);
            availableColors.add(colorToAdd);
        }
        for (int i = 0; i < numberOfItems; i++) {
            int randomValue = PApplet.parseInt(random(0, availableColors.size()));
            sequenceToPlay.add(availableColors.get(randomValue).identifier);
        }
    }

    public void play() {
        for (int i = 0; i < sequenceToPlay.size(); i++) {
            println("sequenceToPlay["+i+"] = "+sequenceToPlay.get(i));
        }
    }

    public void win() {
        println("WIN !!");
    }
}

class SimonResolver
{
    ArrayList<Integer> sequenceToResolve = new ArrayList<Integer>();
    int currentIndex = 0;

    SimonResolver(ArrayList<Integer> receivedSequence) {
        sequenceToResolve = receivedSequence;
    }

    public int compareSolution(int valueSent) {
        if (valueSent == sequenceToResolve.get(currentIndex)) {
            if (currentIndex == sequenceToResolve.size()-1) {
                return 2;
            }
            else {
                currentIndex++;
                return 1;
            }
        }
        else {
            currentIndex = 0;
            return 0;
        }
    }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SimonPong_Processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
