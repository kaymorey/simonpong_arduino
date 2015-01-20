import processing.serial.*;
import ddf.minim.*;

Serial myPort;
String stringReceived;
String[] moves;

// int playerTop;
// int playerBottom;
Game game;
int screenWidth  = 1280;
int screenHeight = 768;
Minim minim;//audio context

int playerTopLeft;
int playerTopRight;

// Pong
Pong pongLeft;
Pong pongRight;

// Players
int playersNumber = 4;
ArrayList<Player> players = new ArrayList<Player>();

// Ball
Ball balls;
Ball balls2;
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
int numberOfLed = 4;
int numberOfColorInSequence = 3;

// SimonResolver
SimonResolver simonResolver;
boolean hasWaitedToReadInput = false;
int returnedValueByResolver = 0; // /!\ cette variable doit être celle du joueur et récupérée pour chaque joueur. N'apparaît pas dans le main.


boolean hasWaited = false;

void setup() {

    minim = new Minim(this);
    game = new Game(minim);

    game.backgroundSound.player.play();

    //instantiateArduino();

    size(screenWidth, screenHeight);
    background(41, 41, 41);

    for (int i = 0; i < playersNumber; i++) {
        players.add(new Player(minim, i));
    }

    balls = new Ball(radiusBall, posXBall/2, posYBall);
    balls2 = new Ball(radiusBall, 3*(screenWidth/4), posYBall);

    scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);

    pongLeft = new Pong(game, screenWidth/2, screenHeight, 0, 0, color(41, 118, 174), players, balls, 0);
    pongRight = new Pong(game, screenWidth/2, screenHeight, screenWidth/2, 0, color(251, 211, 89), players, balls2, 1);

    simon = new Simon(numberOfColorInSequence, numberOfLed);
    simonResolver = new SimonResolver(simon.sequenceToPlay);

    simon.play();
}

void draw()
{
    pongLeft.draw();
    pongRight.draw();
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

            if(moves.length == 3){
                switch (int(moves[2].trim())) {
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

                playerTopLeft = int(moves[1].trim());
                playerTopRight = int(moves[0].trim());
                /* from 0q to 255 */
                // println("playerLeft: "+playerLeft);
                // println("playerRight: "+playerRight);
                players.get(0).bar.posX = playerTopLeft*(screenWidth/2-players.get(0).bar.width)/255;
                players.get(1).bar.posX = playerTopRight*(screenWidth/2-players.get(1).bar.width)/255 + screenWidth/2;
            }
        }
    }
}

void resetSimon()
{
    returnedValueByResolver = 0;
    simon.win();
    simon = new Simon(++numberOfColorInSequence,numberOfLed);
    simonResolver = new SimonResolver(simon.sequenceToPlay);
    simon.play();
}

void readKeyboard()
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
            else if (key == 'a' || key == 'A') {
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
            else if (key == 'w' || key == 'W') {
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
            else if (key == 'e' || key == 'E') {
                players.get(0).bar.expandBar();
            }
            else if (key == 'r' || key == 'R') {
                players.get(0).bar.shrinkBar();
            }
            else if (key == 'i' || key == 'I') {
                pongLeft.balls.transparentMalus = true;
                pongLeft.balls.isTransparent = true;
            }
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



