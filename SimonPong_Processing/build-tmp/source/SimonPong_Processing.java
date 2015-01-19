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



Serial myPort;
String stringReceived;
String[] moves;
int playerTop;
int playerBottom;
int screenWidth  = 1280;
int screenHeight = 768;

// Pong
Pong pongLeft;

// Players
int playersNumber = 4;
ArrayList<Player> players = new ArrayList<Player>();

// Ball
Ball balls;
int radiusBall = 20;
int posXBall = screenWidth / 2;
int posYBall = screenHeight / 2;

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

// SimonResolver
SimonResolver simonResolver;
boolean hasWaitedToReadInput = false;


boolean hasWaited = false;

public void setup() {

    //instantiaterduino();

    size(screenWidth, screenHeight);
    background(41, 41, 41);

    for (int i = 0; i < playersNumber; i++) {
        players.add(new Player(i));
    }

    balls = new Ball(radiusBall, posXBall/2, posYBall);

    scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);

    pongLeft = new Pong(screenWidth, screenHeight, 0, 0, color(41, 41, 41), players, balls, 0);

    simon = new Simon(5, 4);
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

    //readArduino();
    readKeyboard();
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

            if(moves.length == 2){

                playerTop = PApplet.parseInt(moves[0].trim());
                playerBottom = PApplet.parseInt(moves[1].trim());
                /* from 0q to 255 */
                // println("playerLeft: "+playerLeft);
                // println("playerRight: "+playerRight);
                // barTop.posXBar = playerTop*(screenWidth-barTop.barWidth)/255;
                // barBottom.posXBar = playerBottom*(screenWidth-barBottom.barWidth)/255;
            }
        }
    }
}

public void readKeyboard()
{
    if (keyPressed) {
        if (key == CODED) {
            // Controls for top left bar
            if (keyCode == LEFT) {
                 if (!players.get(0).bar.controlInverted && players.get(0).bar.posX > 0) {
                     players.get(0).bar.posX -= 5;
                 }
                 else if (players.get(0).bar.controlInverted && players.get(0).bar.posX < screenWidth / 2 - players.get(0).bar.width) {
                     players.get(0).bar.posX += 5;
                 }
             }
             else if (keyCode == RIGHT) {
                 if (!players.get(0).bar.controlInverted && players.get(0).bar.posX < screenWidth / 2 - players.get(0).bar.width) {
                     players.get(0).bar.posX += 5;
                 }
                 else if (players.get(0).bar.controlInverted && players.get(0).bar.posX > 0) {
                     players.get(0).bar.posX -= 5;
                 }
             }
        }
        else {
            // Controls for bottom left bar
            if (key == 'q' || key == 'Q') {
                 if (!players.get(2).bar.controlInverted && players.get(2).bar.posX > 0) {
                     players.get(2).bar.posX -= 5;
                 }
                 else if (players.get(2).bar.controlInverted && players.get(2).bar.posX < screenWidth / 2 - players.get(2).bar.width) {
                     players.get(2).bar.posX += 5;
                 }
             }
             else if ((key == 's' || key == 'S')) {
                 if (!players.get(2).bar.controlInverted && players.get(2).bar.posX < screenWidth / 2 - players.get(2).bar.width) {
                     players.get(2).bar.posX += 5;
                 }
                 else if (players.get(2).bar.controlInverted && players.get(2).bar.posX > 0) {
                     players.get(2).bar.posX -= 5;
                 }
             }
             // Controls for right left bar
             if (key == 'a' || key == 'A') {
                 if (!players.get(1).bar.controlInverted && players.get(1).bar.posX > screenWidth / 2) {
                     players.get(1).bar.posX -= 5;
                 }
                 else if (players.get(1).bar.controlInverted && players.get(1).bar.posX < screenWidth - players.get(1).bar.width) {
                     players.get(1).bar.posX += 5;
                 }
             }
             // Controls for bottom right bar
             else if ((key == 'z' || key == 'Z')) {
                 if (!players.get(1).bar.controlInverted && players.get(1).bar.posX < screenWidth - players.get(1).bar.width) {
                     players.get(1).bar.posX += 5;
                 }
                 else if (players.get(1).bar.controlInverted && players.get(1).bar.posX > screenWidth / 2) {
                     players.get(1).bar.posX -= 5;
                 }
             }
             if (key == 'w' || key == 'W') {
                 if (!players.get(3).bar.controlInverted && players.get(3).bar.posX > screenWidth / 2) {
                     players.get(3).bar.posX -= 5;
                 }
                 else if (players.get(3).bar.controlInverted && players.get(3).bar.posX < screenWidth - players.get(3).bar.width) {
                     players.get(3).bar.posX += 5;
                 }
             }
             else if ((key == 'x' || key == 'X')) {
                 if (!players.get(3).bar.controlInverted && players.get(3).bar.posX < screenWidth - players.get(3).bar.width) {
                     players.get(3).bar.posX += 5;
                 }
                 else if (players.get(3).bar.controlInverted && players.get(3).bar.posX > screenWidth / 2) {
                     players.get(3).bar.posX -= 5;
                 }
             }
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
        }
    }
}




class Ball
{
    int radius;
    int initialPosX;
    int initialPosY;
    int posX;
    int posY;
    int incrementX;
    int incrementY;
    int[] incrementsY = {3, -3};

    Ball(int radiusBall, int initialPosXBall, int initialPosYBall) {
        radius = radiusBall;
        initialPosX = initialPosXBall;
        initialPosY = initialPosYBall;
        posX = initialPosXBall;
        posY = initialPosYBall;
        initIncrements();
    }

    public void initBall()
    {
        posX = initialPosX;
        posY = initialPosY;
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
            default :
                posX = 0;
                posY = 0;
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
// Bars
int barWidth = 100;
int barHeight = 20;

//int barSpeed = 5;
//boolean increase = true;
// Bar Top
/*
int posXBarTop = (screenWidth - barWidth)/2;
int posYBarTop = 0;
// Bar Bottom
int posXBarBottom = (screenWidth - barWidth)/2;
int posYBarBottom = screenHeight - barHeight;
*/

class Player
{
	int index;
	Bar bar;

	Player(int indexPlayer)
	{
		index = indexPlayer;
		bar = new Bar(barWidth, barHeight, index);
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
    ArrayList<Player> players;
    Ball balls;
    int mode;


    Pong(int pongWidth, int pongHeight, int pongPosX, int pongPosY, int pongBackground, ArrayList<Player> pongPlayers, Ball pongBalls, int pongMode) {
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        balls = pongBalls;
        mode = pongMode;
    }

    public void draw()
    {
        size(width, height);
        background(41, 41, 41);
        drawLine();

        switch (mode) {
            case 0 :
                players.get(0).draw();
                players.get(1).draw();
                players.get(2).draw();
                players.get(3).draw();
                break;
            default :

                break;
        }

        /*
        scorePlayerTop.displayScore();
        scorePlayerBottom.displayScore();
        */

        // Score
        if (balls.posY > height) {
            scorePlayerTop.scorePlayer += 1;
            balls.initBall();
        }
        else if (balls.posY < 0) {
            scorePlayerBottom.scorePlayer += 1;
            balls.initBall();
        }

        // Ball
        balls.moveBall();

        if (balls.testBallHitBar(players.get(0).bar)) {
            balls.changeBallDirection(players.get(0).bar.posX, 1);
        }
        else if (balls.testBallHitBar(players.get(1).bar)) {
            balls.changeBallDirection(players.get(1).bar.posX, 1);
        }
        else if (balls.testBallHitBar(players.get(2).bar)) {
            balls.changeBallDirection(players.get(2).bar.posX, -1);
        }
        else if (balls.testBallHitBar(players.get(3).bar)) {
            balls.changeBallDirection(players.get(3).bar.posX, -1);
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
