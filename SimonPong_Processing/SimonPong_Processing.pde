import processing.serial.*;

Serial myPort;
String stringReceived;
String[] moves;
int playerTop;
int playerBottom;
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

// SimonResolver
SimonResolver simonResolver;
boolean hasWaitedToReadInput = false;


boolean hasWaited = false;

void setup() {
    
    //instantiaterduino();

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

    simon = new Simon(5, 4);
    simonResolver = new SimonResolver(simon.sequenceToPlay);

    simon.play();
}

void draw()
{
    pongLeft.draw();
  
/*
    scorePlayerTop.displayScore();
    scorePlayerBottom.displayScore();
*/

    //readArduino();
    readKeyboard();
}

void instantiateArduino()
{
    String portName = Serial.list()[3];
    myPort = new Serial(this, portName, 9600);
}

void readArduino()
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

                playerTop = int(moves[0].trim());
                playerBottom = int(moves[1].trim());
                /* from 0q to 255 */
                // println("playerLeft: "+playerLeft);
                // println("playerRight: "+playerRight);
                // barTop.posXBar = playerTop*(screenWidth-barTop.barWidth)/255;
                // barBottom.posXBar = playerBottom*(screenWidth-barBottom.barWidth)/255;
            }
        }
    }
}

void readKeyboard()
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



